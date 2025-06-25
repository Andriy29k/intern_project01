output "bastion_internal_ip" {
  value = google_compute_instance.bastion.network_interface[0].network_ip
}

output "bastion_external_ip" {
  value = google_compute_instance.bastion.network_interface[0].access_config[0].nat_ip
}

output "frontend_internal_ip" {
  value = google_compute_instance.frontend.network_interface[0].network_ip
}

output "backend_internal_ip" {
  value = google_compute_instance.backend.network_interface[0].network_ip
}

