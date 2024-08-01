#!/bin/bash

# Extract the outputs from Terraform
PUBLIC_IP=$(terraform output -raw public_ip)

# Create the Ansible inventory file
cat > inventory.ini <<EOF
${PUBLIC_IP} ansible_user=ubuntu 
EOF
