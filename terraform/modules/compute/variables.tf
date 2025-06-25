variable "project_id" {
  type    = string
}


variable "machine_type" {
  type    = string
}

variable "image" {
  type    = string
}

variable "size" {
  type    = number
}

variable "region" {
  type    = string
}

variable "network_name" {
  type    = string  
}

variable "zone" {
  type    = string
}

variable "ssh_path" {
  type    = string
}

variable "ssh_user" {
}

variable "public_subnet_name" {}
variable "private_subnet_name" {}
