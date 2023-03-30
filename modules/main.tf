locals {
  gigabyte = 1073741824
}

resource "libvirt_volume" "image" {
  name   = "image"
  source = var.iso
}

resource "libvirt_volume" "disk_resized" {
  for_each       = var.vms
  name           = format("%s_%s", var.project_name, each.key)
  base_volume_id = libvirt_volume.image.id
  size           = local.gigabyte * each.value["size"]
}

resource "libvirt_cloudinit_disk" "cloudinit" {
  name      = format("cloudinit-%s", var.project_name)
  user_data = data.template_file.user_data.rendered
}

resource "libvirt_network" "network" {
  name      = var.network.name
  mode      = var.network.mode
  addresses = split(",", var.network.addresses)
  dhcp {
    enabled = false
  }
}

resource "libvirt_domain" "domains" {
  for_each  = var.vms
  name      = format("%s_%s", var.project_name, each.key)
  memory    = each.value["memory"]
  vcpu      = each.value["cpus"]
  cloudinit = libvirt_cloudinit_disk.cloudinit.id

  network_interface {
    network_id     = libvirt_network.network.id
    addresses      = split(",", each.value["ip"])
    wait_for_lease = false
  }

  disk {
    volume_id = libvirt_volume.disk_resized[each.key].id
  }

}

output "ip_address" {
  value = {
    for k, v in libvirt_domain.domains : k => v.*.network_interface.0.addresses
  }
}
