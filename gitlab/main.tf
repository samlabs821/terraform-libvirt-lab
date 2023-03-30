module "virtual_machines" {
    source = "../modules"
    project_name = "gitlab"
    vms = {
        server = {
          size = 12
          cpus = 4
          memory = "8240"
          ip = "192.168.10.2"
        }
    }
    network = {
      name = "gitlab"
      mode = "nat"
      addresses = "192.168.10.0/24"
    }
    iso = "/home/samskji/Dist/ubuntu-focal-cloud-amd64.img"
}
