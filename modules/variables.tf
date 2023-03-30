variable "project_name" {
  type = string
}

variable "vms" {
  type = map(object({
    size   = number # in gigabytes
    cpus   = number
    memory = string
    ip     = string
  }))
}

variable "iso" {
  type    = string
  default = "/home/samskji/Work/dist/CentOS-7-x86_64-GenericCloud.qcow2"
}

variable "network" {
  type = object({
    name = string
    # mode can be: "nat" (default), "none", "route", "open", "bridge"
    mode      = string
    addresses = string # [ "192.168.120.0/24" ]
  })
}
