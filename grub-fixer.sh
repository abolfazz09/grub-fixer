#!/bin/bash
#to use this script, you have to find the Linux Root Partition and EFI partition
#this script is for fixing grub in any linux distro(arch-debian-fedora) by usuing a live linux distro
#made by Abolfazz09  https://t.me/Abolfazz09  
#github: https://github.com/abolfazz09
#ONLY UEFI Systems!!


#checking root access
if [ "$EUID" -ne 0 ]; then
    echo "Permission denied! Use 'sudo' to use the script."
    exit 1
fi

#checking live-linux or not

echo "Are you using a live Linux?(yes/no)"
read ANSWER
if [ "$ANSWER" = "yes" ]; then
    echo "Great! Script will continue"
elif [ "$ANSWER" = "no" ]; then
    echo "Using the GRUB installer only..."
    if [ ! -f ./scripts/grub-installer.sh ]; then
        echo "grub-installer.sh not found!"
        exit 1
    fi

    bash ./scripts/grub-installer.sh
    exit 0
else
    echo "Wrong answer, try again"
    exit 1
fi
#chrooting into partition
echo "Prepare to chroot into the partition..."
if [ ! -f ./scripts/chrooter.sh ]; then
    echo "chrooter.sh not found!"
    exit 1
fi

bash ./scripts/chrooter.sh
if [ $? -ne 0 ]; then
    echo "Failed to prepare, Please try again."
    exit 1
fi




      


