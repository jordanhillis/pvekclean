![PVEKCLEAN Logo](https://jordanhillis.com/images/github/pvekclean/pvekclean_banner.png)
<div style="text-align:center;padding:0px;;">
Easily remove old/unused PVE kernels on your Proxmox VE system
</div>

### What is PVE Kernel Cleaner?

PVE Kernel Cleaner is a program to compliment Proxmox Virtual Environment which is an open-source server virtualization environment. PVE Kernel Cleaner allows you to purge old/unused kernels filling the /boot directory. As new kernels are released the older ones have to be manually removed frequently to make room for newer ones. This can become quite tedious and require extensive time spent monitoring the system when new kernels are released and when older ones need to be cleared out to make room. With this issue existing, PVE Kernel Cleaner was created to solve it.

## Example Usage

![PVEKCLEAN Example](https://jordanhillis.com/images/github/pvekclean/pvekclean_example1.png)

## Features

* Removes old PVE kernels from your system
* Ability to schedule PVE kernels to automatically be removed on a daily/weekly/monthly basis
* Run a simple pvekclean command for ease of access
* Support for the latest Proxmox versions and PVE kernels

## Latest Version

* v1.0

## Prerequisites

Before using this program you will need to have the following packages installed.
* cron

To install all required packages enter the following command.

##### Debian:

```
sudo apt-get install cron
```

## Installing

To install PVE Kernel Cleaner please enter the following commands

```
git clone https://github.com/jordanhillis/pvekclean.git
cd pvekclean
chmod +x pvekclean.sh
./pvekclean.sh
```

## Updating

To update PVE Kernel Cleaner please run the same commands as described in the "Installing" section.


## Usage

Example of usage:
```
 pvekclean [OPTION]

-f		--force				Remove all old PVE kernels without confirm prompts
-s		--scheduler			Have old PVE kernels removed on a scheduled basis
-v		--version			Shows the current version of pvekclean
-r		--remove			Uninstalls pvekclean from the system
-h		--help				Show these options
```

## Developers

* **Jordan Hillis** - *Lead Developer*

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* This program is not an official program by Proxmox Server Solutions GmbH
