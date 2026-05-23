#!/bin/bash
set -e

sudo apt-get install -y genisoimage gnupg software-properties-common curl wget qemu-system-x86 libvirt-daemon-system libvirt-clients bridge-utils  util-linux-extra

wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get install terraform

sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt-get install -y ansible

sudo usermod -aG libvirt,kvm $USER

sg libvirt -c "virsh pool-define-as --name default --type dir --target /var/lib/libvirt/images"
sg libvirt -c "virsh pool-start default"
sg libvirt -c "virsh pool-autostart default"
sg libvirt -c "virsh net-start default"
sg libvirt -c "virsh net-autostart default"

exec newgrp libvirt

echo "Setup completed successfully, you cantry use terraform!"
