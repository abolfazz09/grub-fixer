#!/bin/bash
#to use this script, you have to find the Linux Root Partition and EFI partition
#this script is for fixing grub in any linux distro(arch-debian-fedora) by usuing a live linux distro
#made by Abolfazz09  https://t.me/Abolfazz09  
#github: https://github.com/abolfazz09
#ONLY UEFI Systems!!


#checking root access
if [ "$EUID" -ne 0 ]; then
    echo "permission denied! use 'sudo' to use the script"
    exit 1
fi

#checking live-linux or not

echo "are you using a live linux?(yes/no)"
read ANSWER
if [ "$ANSWER" = *yes* ]; then
    echo "Great! script will continue"
elif [ "$ANSWER" = *no* ]; then
    echo "usuing only the GRUB installer only..."
    bash ./scripts/grub-installer.sh
    exit 1
else
    echo "wrong answer, try again"
    exit 1
fi
#chrooting into partition
echo "Prepare to chroot into the partition..."
bash ./scripts/chrooter.sh
if [ $? -ne 0 ]; then
    echo "failed to chroot, please try again."
    exit 1
fi




      


