# Variables that need to be set for the build
variable "vcenter_server" {
  type    = string
  description = "The hostname of the vCenter server to use for building"
}

variable "vcenter_user" {
  type    = string
  description = "The username to use when connecting to the vCenter"
}

variable "vcenter_password" {
  type    = string
  sensitive = true
  description = "The password for the vCenter user"
}

variable "vcenter_datacenter" {
  type    = string
  description = "The name of the datacenter within vCenter to build in"
  default = null
}

variable "vcenter_cluster" {
  type    = string
  description = "The name of the cluster to build in"
  default = null
}

variable "vcenter_resource_pool" {
  type    = string
  description = "The name of the resource pool to build in"
  default = null
}

variable "vcenter_datastore" {
  type    = string
  description = "The name of the resource pool to build in"
  default = null
}

variable "esx_host" {
  type    = string
  description = "The hostname of the ESX to build on"
  default = null
}

variable "http_ip" {
  type    = string
  default = "0.0.0.0"
  description = "The IP address to listen on for the packer HTTP server"
}

# Other variables for easy adaption

variable "iso_checksum" {
  type    = string
  default = "file:https://releases.ubuntu.com/22.04.1/SHA256SUMS"
  description = "The checksum for the ISO specified in `iso_url`"
}

variable "iso_url" {
  type    = string
  default = "https://releases.ubuntu.com/22.04.1/ubuntu-22.04.1-live-server-amd64.iso"
  description = "The download url for the installation ISO"
}

variable "boot_wait" {
  type    = string
  default = "3s"
  description = "The time to wait after boot of the VM to start doing anything"
}

variable "disk_size" {
  type    = number
  default = 16384
  description = "The size of the generated VMDK in MB"
}

variable "memsize" {
  type    = number
  default = 2048
  description = "The memory size for the template VM in MB"
}

variable "numcores" {
  type    = number
  default = 2
  description = "The number of cores for the new template VM"
}

variable "numsockets" {
  type    = number
  default = 1
  description = "The number of sockets for the new template VM"
}

variable "os_password" {
  type    = string
  default = "Passw0rd."
  description = "The password for the OS user to be used when connecting to the deployed VM"
}

variable "os_user" {
  type    = string
  default = "ubuntu"
  description = "The username to connect with to the newly delpoyed OS"
}

variable "vm_name" {
  type    = string
  default = "ubuntu2204"
  description = "The name of the VM when building"
}

variable "vm_notes" {
  type    = string
  default = "by Stefan Zimmermann"
  description = "Notes appearing for each deployed VM"
}

variable "boot_command" {
  type    = list(string)
  default = [  "c<wait>",
                "linux /casper/vmlinuz --- autoinstall ds=\"nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/cloudinit/\"",
                "<enter><wait>",
                "initrd /casper/initrd",                    
                "<enter><wait>",
                "boot",
                "<enter>"                    
            ]
  description = "Commands required to start the automated installation process after booting from ISO"
}