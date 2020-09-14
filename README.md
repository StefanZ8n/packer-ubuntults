# ubuntults

## What is this project about?

`ubuntults` is a set of configuration files used to build automated Ubuntu LTS virtual machine
images using [Packer](https://www.packer.io/). This Packer configuration file allows you to OVA
images usable for VMware and VirtualBox on a vSphere ESX host.

## Prerequisites

- [Packer](https://www.packer.io/downloads.html) to run the build process
- [VMware ESXI](https://www.vmware.com/de/products/esxi-and-esx.html) to build on
- [VMware OVF Tool](https://www.vmware.com/support/developer/ovf/) to create the OVA from the
  generated VM

## Build process

- Unattended installation of Ubuntu LTS 20.04 server from downloaded ISO
- Export VM and package as OVA file

## HowTo

### Prepare Build ESX Server

- Default ESXi installation
- Enable SSH service
- Configure guest IP hack via SSH:
  ```sh
  esxcli system settings advanced set -o /Net/GuestIPHack -i 1
  ```

### Prepare Build Host

- Install Packer
- Install VMware OVA Tool and add the installation path to `%PATH%` to find `ovftool`

### Configure Build Variables

There are some variables which can or must be changed before building at the top of the
`ubuntults.json` file. You can overwrite these variables in the file, in a variable file or via
commandline.

See the
[Packer documentation on user variables](https://www.packer.io/docs/templates/user-variables.html)
for details.

- **"iso_url"**\
  By default the .iso of Ubuntu LTS is pulled a mirror close to me.\
  You can change the URL to one closer to your build server.

### How to use Packer

To create a VM image using a vSphere ESX host:

```sh
cd <path-to-git-root-directory>
packer build ubuntults.json
```

Wait for the build to finish to find the generated OVA file in the `output-vmware-iso` folder.

## Default credentials

The default credentials for this VM image are:

| Username | Password    |
| -------- | ----------- |
| `ubuntu` | `Passw0rd.` |
| `root`   | `Passw0rd.` |

## Implementation Details

- The installer enables SSH but packer is not able to log in with the guest credentials, that's why
  I disable the SSH daemon in the `early-commands` in the cloud-init install script.

## Resources

- [Packer build config for Ubuntu server: subiquity vs debian-installer](https://imagineer.in/blog/packer-build-for-ubuntu-20-04/)
- [Ubuntu Autoinstall Reference](https://ubuntu.com/server/docs/install/autoinstall-reference)
- [CloudInit Documentation](https://cloudinit.readthedocs.io/en/latest/topics/datasources/nocloud.html)

## Gitlab-CI Build

The following variables have to be set in the Gitlab UI

| `SMB_PATH` | The UNC path to the SMB share where to put the resulting OVA file - the user running
Gitlab-Runner must have write access |
