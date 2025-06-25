# Bastion
resource "google_compute_instance" "bastion" {
  name         = "bastion"
  project      = var.project_id
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
      size  = var.size
    }
  }


  metadata = {
    ssh-keys = "${var.ssh_user}:${chomp(file(var.ssh_path))}"
  }

  network_interface {
    subnetwork = var.public_subnet_name
    access_config {}
  }

  tags = ["bastion"]
}

# Frontend
resource "google_compute_instance" "frontend" {
  name         = "frontend"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
      size  = var.size
    }
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${chomp(file(var.ssh_path))}"
  }

  network_interface {
    subnetwork = var.private_subnet_name
    # No external IP
  }

  tags = ["frontend"]
}

# Backend
resource "google_compute_instance" "backend" {
  name         = "backend"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
      size  = var.size
    }
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${chomp(file(var.ssh_path))}"
  }

  network_interface {
    subnetwork = var.private_subnet_name
    # No external IP
  }

  tags = ["backend"]
}
