variable "kubeconfig" {
  type    = string
  default = "~/.kube/config"
}

variable "name" {
  type    = string
  default = "example-pv"
}

variable "size" {
  type    = string
  default = "1Gi"
}

variable "host_path" {
  type    = string
  default = "/mnt/data"
}

variable "storage_class" {
  type    = string
  default = "manual"
}

variable "access_mode" {
  type    = string
  default = "ReadWriteOnce"
}

variable "application" {
  type    = string
  default = ""
}
