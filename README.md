# ubuntults

## What is this project about?

`ubuntults` is a set of configuration files used to build automated Ubuntu LTS virtual machine images using [Packer](https://www.packer.io/). 
This Packer configuration file allows you to OVA images usable for VMware and VirtualBox on a vSphere ESX host.

## Prerequisites

* [Packer](https://www.packer.io/downloads) to run the build process
* [VMware vCenter](https://www.vmware.com/products/vcenter-server.html) and [VMware ESXI](https://www.vmware.com/products/esxi-and-esx.html) to build on
* `tar` for building an OVA from the export OVF files

## Build process

- Unattended installation of Ubuntu LTS server from downloaded ISO
- Some cleanup via `post_install.sh` script
- Export VM and package as OVA file

## HowTo

### Prepare Build Host

- Install Packer
- Allow the Packer vSphere plugin through the firewall, as it will serve the preseed file via HTTP on a random port

#### Configure Build Variables

The variables required for the build are defined in the `variables.pkr.hcl` file.
The definition contains also default values to build the latest LTS release.
You can and must overwrite these variables in the file, in a variable file or via commandline.

See the [Packer documentation on user variables](https://www.packer.io/docs/templates/user-variables.html) for details.

#### How to use Packer

To create a VM image using a vCenter connection when you set your environment:

```sh
# Set all the required packer variables for the vSphere connection, e.g. for Windows:
$env:PKR_VAR_vcenter_server="vcenter.domain.name"
$env:PKR_VAR_vcenter_user="build"
$env:PKR_VAR_vcenter_password="Passw0rd."
$env:PKR_VAR_vcenter_datacenter="Build"
$env:PKR_VAR_esx_host="esx.domain.name"
# IP Adress of the interface with default route
$env:PKR_VAR_http_ip=(Get-NetIPAddress -AddressFamily IPv4 -ifIndex (Get-NetRoute -DestinationPrefix 0.0.0.0/0).ifIndex).IPAddress 

cd <path-to-git-root-directory>
# Define var file as required. If not set the latest LTS release will be build
packer build -var-file="ubuntults2204.pkrvars.hcl" .
```

Wait for the build to finish to find the generated OVA file in the `build/` folder.

## Default credentials

The default credentials for this VM image are:

| Username | Password    |
| -------- | ----------- |
| `ubuntu` | `Passw0rd.` |
| `root`   | `Passw0rd.` |

## Resources

- [Packer build config for Ubuntu server: subiquity vs debian-installer](https://imagineer.in/blog/packer-build-for-ubuntu-20-04/)
- [Ubuntu Autoinstall Reference](https://ubuntu.com/server/docs/install/autoinstall-reference)
- [CloudInit Documentation](https://cloudinit.readthedocs.io/en/latest/topics/datasources/nocloud.html)

## Gitlab-CI Build

The Gitlab-CI build copies the resulting OVA to a SMB share for further usage. The following variables have to be set in the Gitlab UI

| `LTS_VERSION` | LTS version to build in form like '2204' for Ubuntu LTS 22.04 |
| `SMB_PATH` | The UNC path to the SMB share where to put the resulting OVA file - the user running Gitlab-Runner must have write access |
