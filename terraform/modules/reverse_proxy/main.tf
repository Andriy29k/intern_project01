resource "google_compute_instance" "reverse_proxy" {
  name         = "reverse-proxy"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
      size  = var.disk_size
    }
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_path)}"
  }

  network_interface {
    subnetwork = var.public_subnet_name
    access_config {} # Public IP
  }

  tags = ["reverse-proxy"]
}
