#!/bin/bash

set -e

if ! command -v jq &> /dev/null; then
    sudo apt-get update && sudo apt-get install -y jq
fi

cd ../../terraform

terraform output -json | tee tf_outputs.json

if [[ ! -s tf_outputs.json ]]; then
  echo "Terraform output is empty or file not found."
  exit 1
fi

BASTION_IP=$(jq -r '.bastion_external_ip.value' tf_outputs.json)
FRONTEND_IP=$(jq -r '.frontend_internal_ip.value' tf_outputs.json)
BACKEND_IP=$(jq -r '.backend_internal_ip.value' tf_outputs.json)
REVERSE_PROXY_IP=$(jq -r '.reverse_proxy_internal_ip.value' tf_outputs.json)
MONITORING_IP=$(jq -r '.monitoring_internal_ip.value' tf_outputs.json)
DATABASE_IP=$(jq -r '.database_internal_ip.value' tf_outputs.json)
SSH_USER=$(jq -r '.ssh_user.value' tf_outputs.json)

BASTION_KEY="$HOME/.ssh/id_rsa_bastion"
OVER_BASTION_KEY="$HOME/.ssh/id_rsa_over_bastion"

if [[ ! -f "$BASTION_KEY" ]]; then
  echo "Key not found: $BASTION_KEY"
  exit 1
fi
if [[ ! -f "$OVER_BASTION_KEY" ]]; then
  echo "Key over bastion not found: $OVER_BASTION_KEY"
  exit 1
fi

cd ../ansible

INVENTORY_PATH="inventory.ini"

echo "Inventory generation..."
cat > "$INVENTORY_PATH" <<EOF
[bastion_group]
bastion ansible_host=$BASTION_IP ansible_user=$SSH_USER ansible_ssh_private_key_file=$BASTION_KEY 

[frontend_group]
frontend ansible_host=$FRONTEND_IP ansible_user=$SSH_USER ansible_ssh_private_key_file=$OVER_BASTION_KEY ansible_ssh_common_args="-o ProxyJump=$SSH_USER@$BASTION_IP -o IdentityFile=/var/lib/jenkins/.ssh/id_rsa_bastion"

[backend_group]
backend ansible_host=$BACKEND_IP ansible_user=$SSH_USER ansible_ssh_private_key_file=$OVER_BASTION_KEY ansible_ssh_common_args="-o ProxyJump=$SSH_USER@$BASTION_IP -o IdentityFile=/var/lib/jenkins/.ssh/id_rsa_bastion"

[monitoring_group]
monitoring ansible_host=$MONITORING_IP ansible_user=$SSH_USER ansible_ssh_private_key_file=$OVER_BASTION_KEY ansible_ssh_common_args="-o ProxyJump=$SSH_USER@$BASTION_IP -o IdentityFile=/var/lib/jenkins/.ssh/id_rsa_bastion"

[reverse_proxy_group]
reverse_proxy ansible_host=$REVERSE_PROXY_IP ansible_user=$SSH_USER ansible_ssh_private_key_file=$OVER_BASTION_KEY ansible_ssh_common_args="-o ProxyJump=$SSH_USER@$BASTION_IP -o IdentityFile=/var/lib/jenkins/.ssh/id_rsa_bastion"

[database_group]
database ansible_host=$DATABASE_IP ansible_user=$SSH_USER ansible_ssh_private_key_file=$OVER_BASTION_KEY ansible_ssh_common_args="-o ProxyJump=$SSH_USER@$BASTION_IP -o IdentityFile=/var/lib/jenkins/.ssh/id_rsa_bastion"
EOF

echo "Success!"
