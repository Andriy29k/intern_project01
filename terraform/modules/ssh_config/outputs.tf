output "ssh_config_summary" {
  description = "Summary of SSH config entries: machine, IP, user, key file"
  value = concat(
    [
      {
        machine = "bastion"
        ip      = var.bastion_public_ip
        user    = var.ssh_user
        key     = var.ssh_path_to_bastion
      }
    ],
    [
      for m in var.machines : {
        machine = m
        ip      = var.machine_private_ips[m]
        user    = var.ssh_user
        key     = var.ssh_path_over_bastion
      }
    ]
  )
}
