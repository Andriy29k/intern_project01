resource "google_compute_instance" "database" {
  name         = "database"
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
    # Без access_config => немає зовнішнього IP
  }

  tags = ["database"]
}
