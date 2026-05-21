terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.6"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///session"
}

resource "libvirt_volume" "ubuntu_base" {
  name   = "ubuntu-base.qcow2"
  pool   = "default"
  source = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  format = "qcow2"
}

resource "libvirt_volume" "worker_disk" {
  name           = "worker-disk.qcow2"
  base_volume_id = libvirt_volume.ubuntu_base.id
  pool           = "default"
  size           = 10 * 1024 * 1024 * 1024
}

resource "libvirt_volume" "db_disk" {
  name           = "db-disk.qcow2"
  base_volume_id = libvirt_volume.ubuntu_base.id
  pool           = "default"
  size           = 10 * 1024 * 1024 * 1024
}

resource "libvirt_cloudinit_disk" "worker_init" {
  name = "worker-init.iso"

  user_data = file("${path.module}/cloud_init.cfg")
  pool      = "default"
}

resource "libvirt_cloudinit_disk" "db_init" {
  name = "db-init.iso"

  user_data = file("${path.module}/cloud_init.cfg")
  pool      = "default"
}

resource "libvirt_domain" "vm_worker" {
  name   = "vm-worker"
  memory = 2048
  vcpu   = 2

    machine = "pc-i440fx-2.12"

  cloudinit = libvirt_cloudinit_disk.worker_init.id

  network_interface {
    network_name   = "default"
    wait_for_lease = true
  }

  disk {
    volume_id = libvirt_volume.worker_disk.id
  }
}

resource "libvirt_domain" "vm_db" {
  name   = "vm-db"
  memory = 1024
  vcpu   = 1
    machine = "pc-i440fx-2.12"

  cloudinit = libvirt_cloudinit_disk.db_init.id

  network_interface {
    network_name   = "default"
    wait_for_lease = true
  }

  disk {
    volume_id = libvirt_volume.db_disk.id
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }
}