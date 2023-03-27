iso_checksum = "file:https://releases.ubuntu.com/focal/SHA256SUMS"
iso_url = "http://releases.ubuntu.com/focal/ubuntu-20.04.6-live-server-amd64.iso"
vm_name = "ubuntults2004"
boot_command = [    
                    "<esc><esc><f6><esc><wait>",
                    "autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/cloudinit/ fsck.mode=skip",
                    "<enter><wait>"
                ]
