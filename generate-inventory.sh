#!/bin/bash

WORKER_IP=$(virsh domifaddr worker-vm | awk '/ipv4/ {print $4}' | cut -d'/' -f1)
DB_IP=$(virsh domifaddr db-vm | awk '/ipv4/ {print $4}' | cut -d'/' -f1)

cat > ./ansible/inventory.ini <<EOF
[workers]
worker ansible_host=$WORKER_IP ansible_user=ansible ansible_ssh_private_key_file=ansible_id_rsa

[db]
db ansible_host=$DB_IP ansible_user=ansible ansible_ssh_private_key_file=ansible_id_rsa
EOF