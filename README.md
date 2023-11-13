![PVEKCLEAN Logo](https://raw.githubusercontent.com/jordanhillis/pvekclean/master/assets/banner.png)

Easily remove old/unused PVE kernels on your Proxmox VE system

[![Version](https://img.shields.io/badge/Version-v2.0.2-brightgreen)](https://github.com/jordanhillis/pvekclean)
[![License: MIT](https://img.shields.io/badge/License-MIT-brightgreen.svg)](https://opensource.org/licenses/MIT)
![Updated](https://img.shields.io/github/last-commit/jordanhillis/pvekclean)
![Proxmox](https://img.shields.io/badge/-Proxmox-orange)
![Debian](https://img.shields.io/badge/-Debian-red)

### What is PVE Kernel Cleaner?

PVE Kernel Cleaner is a program to compliment Proxmox Virtual Environment which is an open-source server virtualization environment. PVE Kernel Cleaner allows you to purge old/unused kernels filling the /boot directory. As new kernels are released the older ones have to be manually removed frequently to make room for newer ones. This can become quite tedious and require extensive time spent monitoring the system when new kernels are released and when older ones need to be cleared out to make room. With this issue existing, PVE Kernel Cleaner was created to solve it.

## Example Usage

![PVEKCLEAN Example](https://raw.githubusercontent.com/jordanhillis/pvekclean/master/assets/example-2.0.2.png)

## Features

* Removes old PVE kernels from your system
* Ability to schedule PVE kernels to automatically be removed on a daily/weekly/monthly basis
* Run a simple pvekclean command for ease of access
* Checks health of boot disk based on space available
* Debug mode for non-destructive testing
* Update function to easily update the program to the latest version
* Allows you to specify the minimum number of most recent PVE kernels to retain
* Support for the latest Proxmox versions and PVE kernels

## Latest Version

* v2.0.2

## Prerequisites

Before using this program you will need to have the following packages installed.
* cron
* curl
* git

To install all required packages enter the following command.

##### Debian:

```
sudo apt-get install cron curl git
```

## Installing

You can install PVE Kernel Cleaner using either Git or Curl. Choose the method that suits you best:

### Installation via Git

1. Open your terminal.

2. Enter the following commands one by one to install PVE Kernel Cleaner:

```bash
git clone https://github.com/jordanhillis/pvekclean.git
cd pvekclean
chmod +x pvekclean.sh
./pvekclean.sh
```
### Installation via Curl

1. Open your terminal.

2. Use the following command to install PVE Kernel Cleaner:

```bash
curl -o pvekclean.sh https://raw.githubusercontent.com/jordanhillis/pvekclean/master/pvekclean.sh
chmod +x pvekclean.sh
./pvekclean.sh
```

## Updating

PVE Kernel Cleaner checks for updates automatically when you run it. If an update is available, you'll be notified within the program. Simply follow the on-screen instructions to install the update, and you're all set with the latest version!

## Usage

Example of usage:
```
 pvekclean [OPTION1] [OPTION2]...

-k, --keep [number]   Keep the specified number of most recent PVE kernels on the system
                      Can be used with -f or --force for non-interactive removal
-f, --force           Force the removal of old PVE kernels without confirm prompts
-rn, --remove-newer   Remove kernels that are newer than the currently running kernel
-s, --scheduler       Have old PVE kernels removed on a scheduled basis
-v, --version         Shows current version of pvekclean
-r, --remove          Uninstall pvekclean from the system
-i, --install         Install pvekclean to the system
-d, --dry-run         Run the program in dry run mode for testing without making system changes

```

## Usage Examples:
Here are some common ways to use PVE Kernel Cleaner:

* **Remove Old Kernels Non-Interactively:**
```bash
pvekclean -f
```
<sub> This command removes old PVE kernels without requiring user confirmation.</sub>

* **Set Number of Kernels to Keep:**
```bash
pvekclean -k 3
```
<sub>This command specifies the number of most recent PVE kernels to keep on the system.</sub>

* **Force Remove Old Kernels While Keeping a Certain Number:**
```bash
pvekclean -f -k 3
```
<sub>This command forces the removal of old PVE kernels while retaining a specific number of the most recent ones.</sub>

* **Remove Newer Kernels and Keep a Specific Number:**
```bash
pvekclean -rn -k 2
```
<sub>This command removes newer PVE kernels and keeps a specified number of the most recent ones.</sub>

* **Schedule Regular Kernel Removal:**
```bash
pvekclean -s
```
<sub>This command sets up PVE Kernel Cleaner to remove old PVE kernels on a scheduled basis. You can configure the schedule according to your needs.</sub>

* **Perform a Dry Run without Making Changes:**
```bash
pvekclean -d
```
<sub>This command runs PVE Kernel Cleaner in dry run mode, simulating actions without actually removing any kernels or making changes to your system. It's useful for testing and understanding what the script would do.</sub>

## Developers

* **Jordan Hillis** - *Lead Developer*

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* This program is not an official program by Proxmox Server Solutions GmbH
