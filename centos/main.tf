locals {
  gigabyte = 1073741824
}

resource "libvirt_volume" "centos_image" {
  name   = "centos_iso"
  source = var.iso
}

resource "libvirt_volume" "disk_resized" {
  for_each       = var.vms
  name           = format("%s_%s", each.value["project"], each.key)
  base_volume_id = libvirt_volume.centos_image.id
  size           = local.gigabyte * each.value["size"]
}

resource "libvirt_cloudinit_disk" "cloudinit" {
  name      = "cloudinit"
  user_data = data.template_file.user_data.rendered
}

resource "libvirt_domain" "domains" {
  for_each  = var.vms
  name      = format("%s_%s", each.value["project"], each.key)
  memory    = each.value["memory"]
  vcpu      = each.value["cpus"]
  cloudinit = libvirt_cloudinit_disk.cloudinit.id

  network_interface {
    network_name   = "default"
    wait_for_lease = true
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
