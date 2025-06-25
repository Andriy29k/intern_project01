output "bastion_internal_ip" {
  value = module.compute.bastion_internal_ip
}

output "bastion_external_ip" {
  value = module.compute.bastion_external_ip
}

output "frontend_internal_ip" {
  value = module.compute.frontend_internal_ip
}

output "backend_internal_ip" {
  value = module.compute.backend_internal_ip
}

output "database_internal_ip" {
  value = module.database.database_internal_ip
}

output "reverse_proxy_internal_ip" {
  value = module.reverse_proxy.reverse_proxy_internal_ip
}

output "reverse_proxy_external_ip" {
  value = module.reverse_proxy.reverse_proxy_external_ip
}

output "ssh_bastion_command" {
  value = "ssh ${var.ssh_user}@${module.compute.bastion_external_ip}"
}

output "ssh_frontend_via_bastion" {
  value = "ssh -J ${var.ssh_user}@${module.compute.bastion_external_ip} ${var.ssh_user}@${module.compute.frontend_internal_ip}"
}