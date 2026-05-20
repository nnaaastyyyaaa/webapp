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

resource "libvirt_network" "lab" {
  name = "lab-net"
  mode = "nat"

  addresses = ["192.168.100.0/24"]
}

resource "libvirt_volume" "ubuntu" {
  name   = "ubuntu-base.qcow2"
  pool   = "default"
  source = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
  format = "qcow2"
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name = "commoninit.iso"

  user_data = file("./user-data.yaml")
}

resource "libvirt_domain" "vm" {
    count = 2

  name   = count.index == 0 ? "worker" : "db"
  memory = var.VMMemory
  vcpu   = 2

  disk {
    volume_id = libvirt_volume.ubuntu.id
  }

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    network_id = libvirt_network.lab.id
  }

}
