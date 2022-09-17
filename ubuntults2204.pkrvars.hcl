iso_checksum = "file:https://releases.ubuntu.com/jammy/SHA256SUMS"
iso_url = "https://releases.ubuntu.com/jammy/ubuntu-22.04.1-live-server-amd64.iso"
vm_name = "ubuntults2204"
boot_command = [  
                    "c<wait>",
                    "linux /casper/vmlinuz --- autoinstall ds=\"nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/cloudinit/\"",
                    "<enter><wait>",
                    "initrd /casper/initrd",                    
                    "<enter><wait>",
                    "boot",
                    "<enter>"                    
                ]