variable "vms" {
  type = map(object({
    project = string
    size    = number # in gigabytes
    cpus    = number
    memory  = string
  }))
}

variable "iso" {
  type    = string
  default = "/home/samskji/Work/dist/CentOS-7-x86_64-GenericCloud.qcow2"
}
