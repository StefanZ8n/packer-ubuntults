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
- Export VM and package as OVA file

## HowTo

### Prepare Build Host

- Install Packer
- Allow the Packer vSphere plugin through the firewall, as it will serve the preseed file via HTTP on a random port

#### Configure Build Variables

There are some variables which can or must be changed before building at the top of the `.pkr.hcl` file. 
You can overwrite these variables in the file, in a variable file or via commandline.

See the [Packer documentation on user variables](https://www.packer.io/docs/templates/user-variables.html) for details.

- **"iso_url"**\
  By default the .iso of Ubuntu LTS is pulled a mirror close to me.\
  You can change the URL to one closer to your build server.

#### How to use Packer

To create a VM image using a vSphere ESX host:

```sh
cd <path-to-git-root-directory>
packer build .
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

The following variables have to be set in the Gitlab UI

| `SMB_PATH` | The UNC path to the SMB share where to put the resulting OVA file - the user running Gitlab-Runner must have write access |
