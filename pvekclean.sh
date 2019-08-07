#!/bin/bash
: '
______________________________________________

              PVE Kernel Cleaner
               By Jordan Hillis
           contact@jordanhillis.com
           https://jordanhillis.com
______________________________________________

MIT License

Copyright (c) 2018 Jordan S. Hillis

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
______________________________________________
'

# Percentage of used space in the /boot which would consider it critically full
boot_critical_percent="80"

# Current kernel
current_kernel=$(uname -r)

# Name of the program
program_name="pvekclean"

# Version
version="1.2"

# Check if force removal argument is added
if [ "$1" == "-f" ] || [ "$1" == "--force" ]; then
	force_purge=true
else
	force_purge=false
fi

# Check if script is ran as root, if not exit
function check_root() {
	if [[ $EUID -ne 0 ]]; then
		printf "[!] Error: this script must be ran as the root user.\n" 
		exit 1
	fi
}

# Shown current version
function version() {
  printf $version"\n"
  exit 1
}

# Header for PVE Kernel Cleaner
function header_info() {
echo -e "
█▀▀█ ▀█ █▀ █▀▀   █ █ █▀▀ █▀▀█ █▀▀▄ █▀▀ █   
█  █  █▄█  █▀▀   █▀▄ █▀▀ █▄▄▀ █  █ █▀▀ █     
█▀▀▀   ▀   ▀▀▀   ▀ ▀ ▀▀▀ ▀ ▀▀ ▀  ▀ ▀▀▀ ▀▀▀  

█▀▀ █   █▀▀ █▀▀█ █▀▀▄ █▀▀ █▀▀█  
█   █   █▀▀ █▄▄█ █  █ █▀▀ █▄▄▀   ⎦˚◡˚⎣ v$version
▀▀▀ ▀▀▀ ▀▀▀ ▀  ▀ ▀  ▀ ▀▀▀ ▀ ▀▀    
By Jordan Hillis [contact@jordanhillis.com]
___________________________________________
"
}

# Show current system information
function kernel_info() {
	# Lastest kernel installed
	latest_kernel=$(dpkg --list| awk '/pve-kernel-.*-pve/ {print $2}' | tac | head -n 1)
	# Show operating system used
	printf "OS: $(grep "PRETTY_NAME" /etc/os-release | sed -e 's/PRETTY_NAME=//g' -e 's/["]//g' | awk '{print $0}')\n"
	# Get information about the /boot folder
	boot_info=($(df -Ph /boot | tail -1 | sed 's/%//g'))
	# Show information about the /boot
	printf "Boot Disk: ${boot_info[4]}%% full [${boot_info[2]}/${boot_info[1]} used, ${boot_info[3]} free] \n"
	# Show current kernel in use
	printf "Current Kernel: pve-kernel-$current_kernel\n"
	# Check if they are running a PVE kernel
	if [[ "$current_kernel" == *"pve"* ]]; then
		# Check if we are running the latest kernel, if not warn
		if [[ "$latest_kernel" != *"$current_kernel"* ]]; then
			printf "Latest Kernel: $latest_kernel\n"
		fi
	# Warn them that they aren't on a PVE kernel
	else
		printf "___________________________________________\n\n"
		printf "[!] Warning, you're not running a PVE kernel\n"
		# Ask them if they want to continue
		read -p "[*] Would you like to continue [y/N] " -n 1 -r
		printf "\n"
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			# Continue on if they wish
			printf "[-] Alright, we will continue on\n"
		else
			# Exit script
			printf "\nGood bye!\n"
			exit 1
		fi
	fi
	printf "___________________________________________\n\n"
}

# Usage information on how to use PVE Kernel Clean
function show_usage() {
	# Skip showing usage when force_purge is enabled
	if [ $force_purge == false ]; then
		printf "Usage: $(basename $0) [OPTION]\n\n"
		printf "  -f,   --force         Remove all old PVE kernels without confirm prompts\n"
		printf "  -s    --scheduler     Have old PVE kernels removed on a scheduled basis\n"
		printf "  -v,   --version       Shows current version of $program_name\n"
		printf "  -r    --remove        Uninstall $program_name from the system\n"
		printf "___________________________________________\n\n"
	fi
}

# Schedule PVE Kernel Cleaner at a time desired
function scheduler() {
	# Check if pvekclean is on the system, if not exit
	if [ ! -f /usr/local/sbin/$program_name ]; then
		printf "[!] Sorry $program_name is required to be installed on the system for this functionality.\n"
		exit 1
	fi
	# Check if cron is installed
    if ! [ -x "$(command -v crontab)" ]; then
      printf "[*] Error, cron does not appear to be installed.\n"
      printf "    Please install cron with the command 'sudo apt-get install cron'\n\n"
      exit 1
    fi
	# Check if the cronjob exists on the system
	check_cron_exists=$(crontab -l | grep "$program_name")
	# Cronjob exists
	if [ -n "$check_cron_exists" ]; then
		# Get the current cronjob scheduling 
		cron_current=$(crontab -l | grep "$program_name" | sed -e "s/[^a-zA-Z']/ /g" -e "s/\b\(.\)/\u\1/g" | awk '{print $1;}')
		# Ask the user if they would like to remove the scheduling
		read -p "[-] Would you like to remove the currently scheduled PVE Kernel Cleaner? (Current: $cron_current) [y/N] " -n 1 -r
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			# Remove the cronjob
			(crontab -l | grep -v "$program_name")| crontab -
			printf "\n[*] Successfully removed the ${cron_current,,} scheduled PVE Kernel Cleaner!\n"
		else
			# Keep it
			printf "\n\nAlright we will keep your current settings then.\n"
		fi
	# Cronjob does not exist
	else
		# Ask how often the would like to check for old PVE kernels
		printf "[-] How often would you like to check for old PVE kernels?\n    1) Daily\n    2) Weekly\n    3) Monthly\n\n  - Enter a number option above? "
		read -r -p "" response
		case "$response" in
			1)
				cron_time="daily"
			;;
			2)
				cron_time="weekly"
			;;
			3)
				cron_time="monthly"
			;;
			*)
				printf "\nThat is not a valid option!\n"
				exit 1
			;;
		esac
		# Add the cronjob
		(crontab -l ; echo "@$cron_time /usr/local/sbin/$program_name -f")| crontab -
		printf "\n[-] Scheduled $cron_time PVE Kernel Cleaner successfully!\n"
	fi
	exit 1
}

# Installs PVE Kernel Cleaner for easier access
function install_program() {
	force_pvekclean_update=false
	# If pvekclean exists on the system
	if [ -e /usr/local/sbin/$program_name ]; then
		# Get current version of pvekclean
		pvekclean_installed_version=$(/usr/local/sbin/$program_name -v | awk '{printf $0}')
		# If the version differs, update it to the latest from the script
		if [ $version != $pvekclean_installed_version ] && [ $force_purge == false ]; then
			printf "[!] A new version of PVE Kernel Cleaner has been detected (Installed: $pvekclean_installed_version | New: $version).\n"
			printf "[*] Installing update...\n"
			force_pvekclean_update=true
		fi
	fi
	# If pvekclean does not exist on the system or force_purge is enabled
	if [ ! -f /usr/local/sbin/$program_name ] || [ $force_pvekclean_update == true ]; then
		# Ask user if we can install it to their system
		if [ $force_purge == true ]; then
			REPLY="n"
		else
			# Ask if we can install it
			read -p "[-] Can we install PVE Kernel Cleaner to your /usr/local/sbin for easier access [y/N] " -n 1 -r
			printf "\n"
		fi
		# User agrees to have it installed
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			# Copy the script to /usr/local/sbin and set execution permissions
			cp $0 /usr/local/sbin/$program_name
			chmod +x /usr/local/sbin/$program_name
			# Tell user how to use it
			printf "[*] Installed PVE Kernel Cleaner to /usr/local/sbin/$program_name\n"
			printf "[*] Run the command \"$program_name\" to begin using this program.\n"
			printf "[-] Run the command \"$program_name -r\" to remove this program at any time.\n"
			exit 1
		fi
	fi
}

# Uninstall pvekclean from the system
function uninstall_program() {
	# If pvekclean exists on the system
	if [ -e /usr/local/sbin/$program_name ]; then
		# Confirm that they wish to remove it
		read -p "[-] Are you sure that you would like to remove $program_name? [y/N] " -n 1 -r
		printf "\n"
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			# Remove the program
			rm -f /usr/local/sbin/$program_name
			printf "[*] Successfully removed PVE Kernel Cleaner from the system!\n"
			printf "[-] Sorry to see you go :(\n"
		else
			printf "\nExiting...\nThat was a close one ⎦˚◡˚⎣\n"
		fi
		exit 1
	else
		# Tell the user that it is not installed
		printf "[!] This program is not installed on the system.\n"
		exit 1
	fi
}

# PVE Kernel Clean main function
function pve_kernel_clean() {
	# Find all the PVE kernels on the system
	kernels=$(dpkg --list| awk '/pve-kernel-.*-pve/ {print $2}' | sort -V)
	# List of kernels that will be removed (adds them as the script goes on)
	kernels_to_remove=""
	# Check the /boot used
	printf "[*] Boot disk space used is "
	# Warn user when the /boot is critically full
	if [[ "${boot_info[4]}" -ge "$boot_critical_percent" ]]; then
		printf "critically full "
	# Tell them if it is at an acceptable percentage
	else
		printf "healthy "
	fi
	# Display percentage used and available space left
	printf "at ${boot_info[4]}%% capacity (${boot_info[3]} free)\n"
	printf "[-] Searching for old PVE kernels on your system...\n"
	# For each kernel that was found via dpkg
	for kernel in $kernels
	do
		# If the kernel listed from dpkg is our current then break
		if echo $kernel | grep -q $current_kernel; then
			break
		# Add kernel to the list of removal since it is old
		else
			printf "[*] \"$kernel\" has been added to the kernel remove list\n"
			kernels_to_remove+=" $kernel"
		fi
	done
	printf "[-] PVE kernel search complete!\n"
	# If there are no kernels to be removed then exit
	if [[ "$kernels_to_remove" != *"pve"* ]]; then
		printf "[!] It appears there are no old PVE kernels on your system ⎦˚◡˚⎣\n"
		printf "[-] Good bye!\n"
	# Kernels found in removal list
	else
		# Check if force removal was passed
		if [ $force_purge == true ]; then
			REPLY="y"
		# Ask the user if they want to remove the selected kernels found
		else
			read -p "[!] Would you like to remove the $(echo $kernels_to_remove | awk '{print NF}') selected PVE kernels listed above? [y/N]: " -n 1 -r
			printf "\n"
		fi
		# User wishes to remove the kernels
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			printf "[*] Removing $(echo $kernels_to_remove | awk '{print NF}') old PVE kernels..."
			# Purge the old kernels via apt and suppress output
			/usr/bin/apt purge -y $kernels_to_remove > /dev/null 2>&1
			printf "DONE!\n"
			printf "[*] Updating GRUB..."
			# Update grub after kernels are removed, suppress output
			/usr/sbin/update-grub > /dev/null 2>&1
			printf "DONE!\n"
			# Script finished successfully
			printf "[-] Have a nice day ⎦˚◡˚⎣\n"
		# User wishes to not remove the kernels above, exit
		else
			printf "\nExiting...\n"
			printf "See you later ⎦˚◡˚⎣\n"
		fi
	fi
}

function main() {
	# Check for root
	check_root
	# Show header information
	header_info
	# Script usage
	show_usage
	# Show kernel information
	kernel_info
	# Install program to /usr/local/sbin/
	install_program
}

while true; do
	case "$1" in
		-r | --remove )
			main
			uninstall_program
		;;
		-s | --scheduler )
			main
			scheduler
		;;
		-v | --version )
			version
		;;
		-h | --help )
			main
			exit 1
		;;
		* )
			main
			pve_kernel_clean
			exit 1
		;;
    esac
    shift
done
