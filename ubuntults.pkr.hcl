packer {
  required_plugins {
    vsphere = {
      version = ">= 0.0.1"
      source = "github.com/hashicorp/vsphere"
    }
  }
}

source "vsphere-iso" "ubuntults" {
  # Deployment Connection Details
  vcenter_server = "${var.vcenter_server}"
  username = "${var.vcenter_user}"
  password = "${var.vcenter_password}"
  datacenter = "${var.vcenter_datacenter}"
  cluster = "${var.vcenter_cluster}"
  host = "${var.esx_host}"
  datastore = "${var.vcenter_datastore}"

  http_ip = "${var.http_ip}"
  http_directory = "./resources"

  insecure_connection = true

  # VM Details
  vm_name = "${var.vm_name}"
  vm_version = 17
  guest_os_type = "ubuntu64Guest"  
  CPUs = "${var.numcores}"
  cpu_cores = "${var.numcores}"  
  RAM = "${var.memsize}"
  disk_controller_type = ["pvscsi"]
  network_adapters {
    network = "VM Network"
    network_card = "vmxnet3"
  }
  storage {
    disk_size = "${var.disk_size}"
    disk_thin_provisioned = true
  }
  notes = "${var.vm_notes}"  
  
  # Boot details
  iso_checksum = "${var.iso_checksum}"
  iso_paths = []
  iso_url = "${var.iso_url}"

  boot_wait = "${var.boot_wait}"  
  boot_command = var.boot_command

  # OS Connection Details
  communicator = "ssh"  
  ssh_clear_authorized_keys = true
  ssh_password = "${var.os_password}"
  ssh_timeout = "1h"
  ssh_username = "${var.os_user}"
  
  shutdown_command = "echo '${var.os_password}' | sudo -S shutdown -h now"
  shutdown_timeout = "60m"
  
  export {
    force            = true
    output_directory = "./build"
  }

}

build {
  name = "ubuntults"

  sources = ["source.vsphere-iso.ubuntults"]

  provisioner "file" {
    source = "resources/scripts/"
    destination = "/tmp/"
  }

  provisioner "shell" {
    inline = [ "echo '${var.os_password}' | sudo -S chmod +x /tmp/post_install.sh" ]
  }

  provisioner "shell" {
    inline = [ "echo '${var.os_password}' | sudo -S /tmp/post_install.sh" ]
  }

}
