#!/bin/bash
set -e

# === CONFIG ===
BASTION_IP=$(jq -r '.bastion_external_ip.value' ../../terraform/tf_outputs.json)
SSH_USER=$(jq -r '.ssh_user.value' ../../terraform/tf_outputs.json)
KNOWN_HOSTS="/var/lib/jenkins/.ssh/known_hosts"

# === IP ===
PRIV_IPS=$(jq -r '[
  .backend_internal_ip.value,
  .frontend_internal_ip.value,
  .monitoring_internal_ip.value,
  .reverse_proxy_internal_ip.value,
  .database_internal_ip.value
] | .[]' ../../terraform/tf_outputs.json)

# === Clean known_hosts ===
echo "[INFO] Cleaning known_hosts: $KNOWN_HOSTS"
rm -f "$KNOWN_HOSTS"

# === bastion ===
for ip in $PRIV_IPS; do
    echo "[INFO] Scanning $ip through bastion $BASTION_IP"
    ssh-keyscan -o "ProxyCommand=ssh -i /var/lib/jenkins/.ssh/id_rsa_bastion -W %h:%p $SSH_USER@$BASTION_IP" -t rsa "$ip" >> "$KNOWN_HOSTS" 2>/dev/null
done

# === bastion ===
echo "[INFO] Scanning bastion $BASTION_IP"
ssh-keyscan -H "$BASTION_IP" >> "$KNOWN_HOSTS" 2>/dev/null

echo "[INFO] known_hosts updated:"
cat "$KNOWN_HOSTS"
