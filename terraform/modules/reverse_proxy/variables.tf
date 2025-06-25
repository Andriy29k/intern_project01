variable "project_id" {}
variable "region" {}
variable "zone" {}
variable "network_name" {}
variable "public_subnet_name" {}

variable "machine_type" {
  default = "e2-small"
}

variable "image" {
  default = "debian-cloud/debian-12"
}

variable "disk_size" {
  default = 10
}

variable "ssh_path" {
  type    = string
  default = "~/.ssh/gcp_id_rsa.pub"
}

variable "ssh_user" {
  default = "andrii"
}