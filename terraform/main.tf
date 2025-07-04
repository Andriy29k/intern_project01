terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.5"
    }
  }
}

provider "google" {
  credentials = var.google_credentials_file
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

module "bastion" {
  source              = "./modules/bastion"
  project_id          = var.project_id
  region              = var.region
  zone                = var.zone
  network_name        = module.network.network_name
  public_subnet_name  = module.network.public_subnet_name
  private_subnet_name = module.network.private_subnet_name
  machine_type        = var.machine_type
  image               = var.image
  size                = var.size
  ssh_path_to_bastion = var.ssh_path_to_bastion
  ssh_user            = var.ssh_user
}

# Compute instances: frontend, backend
module "compute" {
  source                = "./modules/compute"
  project_id            = var.project_id
  region                = var.region
  zone                  = var.zone
  network_name          = module.network.network_name
  public_subnet_name    = module.network.public_subnet_name
  private_subnet_name   = module.network.private_subnet_name
  machine_type          = var.machine_type
  image                 = var.image
  size                  = var.size
  ssh_path_over_bastion = var.ssh_path_over_bastion
  ssh_user              = var.ssh_user
}

module "ssh_config" {
  source = "./modules/ssh_config"

  bastion_public_ip = module.bastion.bastion_external_ip

  machines = keys(module.compute.all_internal_ips)

  machine_private_ips = module.compute.all_internal_ips

  ssh_user              = var.ssh_user
  ssh_path_to_bastion   = var.ssh_path_to_bastion
  ssh_path_over_bastion = var.ssh_path_over_bastion

  depends_on = [module.bastion, module.compute]
}


module "reverse_proxy" {
  source                = "./modules/reverse_proxy"
  project_id            = var.project_id
  region                = var.region
  zone                  = var.zone
  size                  = var.size
  network_name          = module.network.network_name
  public_subnet_name    = module.network.public_subnet_name
  ssh_path_over_bastion = var.ssh_path_over_bastion
  ssh_user              = var.ssh_user
}

# Database instance
module "database" {
  source                = "./modules/database"
  zone                  = var.zone
  db_machine_type       = var.db_machine_type
  image                 = var.image
  size                  = var.size
  ssh_path_over_bastion = var.ssh_path_over_bastion
  ssh_user              = var.ssh_user
  public_subnet_name    = module.network.public_subnet_name
  private_subnet_name   = module.network.private_subnet_name
}

module "storage" {
  source        = "./modules/storage"
  project_id    = var.project_id
  bucket_name   = var.bucket_name
  location      = var.region
  storage_class = var.storage_class
}


