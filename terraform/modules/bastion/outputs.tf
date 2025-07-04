output "bastion_external_ip" {
  description = "Public IP address of bastion"
  value       = google_compute_instance.bastion.network_interface[0].access_config[0].nat_ip
}

output "bastion_external_ip" {
  value = google_compute_instance.bastion.network_interface[0].access_config[0].nat_ip
}
