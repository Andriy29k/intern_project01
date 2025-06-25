terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.5"
    }
  }
}

provider "google" {
  credentials = file(var.google_credentials_file)
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}

# Network module (VPC, subnets, firewalls)
module "network" {
  source              = "./modules/network"
  vpc_name            = var.network_name
  project_id          = var.project_id
  zone                = var.zone
  region              = var.region
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
}

# Compute instances: bastion, frontend, backend, reverse-proxy
module "compute" {
  source              = "./modules/compute"
  project_id          = var.project_id
  region              = var.region
  zone                = var.zone
  network_name        = module.network.network_name
  public_subnet_name  = module.network.public_subnet_name
  private_subnet_name = module.network.private_subnet_name

  machine_type = var.machine_type
  image        = var.image
  size         = var.size
  ssh_path     = var.ssh_path
  ssh_user     = var.ssh_user
}

module "reverse_proxy" {
  source = "./modules/reverse_proxy"

  project_id         = var.project_id
  region             = var.region
  zone               = var.zone
  network_name       = module.network.network_name
  public_subnet_name = module.network.public_subnet_name
}

# Database instance
module "database" {
  source              = "./modules/database"
  zone                = var.zone
  machine_type        = var.machine_type
  image               = var.image
  size                = var.size
  ssh_path            = var.ssh_path
  ssh_user            = var.ssh_user
  public_subnet_name  = module.network.public_subnet_name
  private_subnet_name = module.network.private_subnet_name
}

module "dump_bucket" {
  source      = "./modules/storage"
  project_id  = var.project_id
  bucket_name = var.bucket_name
  location    = var.region
}
