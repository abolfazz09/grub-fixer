#!/bin/bash
#to use this scrtipt, at first find the partition you want to chroot
#this script is for fixing grub in any linux distro(arch-debian-fedora) by usuing a live linux distro
#made by Abolfazz09  https://t.me/Abolfazz09  
#github: https://github.com/abolfazz09
#ONLY UEFI Systems!!!!
#other distros will append soon!

#mounting EFI partition
echo "finding EFI partition"
lsblk
echo "enter your EFI partition name [be carefull while Entering...](example: /dev/nvme0n1p1): "
read EFI
mount $EFI /mnt
mount $EFI /mnt/boot/efi


#Finding Linux Distro Name, Then Installing GRUB
OS_INFO="/etc/os-release"
source "$OS_INFO"
detect_os() {
if [ -f "$OS_INFO" ]; then
    echo "your linux distro is: $ID"
else
    echo "your linux distro was not found"
fi
}
detect_os
debian() {
        apt install grub-efi -y
        grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id="$ID"
        if [ $? -eq 0 ]; then
            echo "GRUB installed successfully!"
            update-grub
        else
            grub-install --target=x86_64-efi --efi-directory=/mnt/boot/efi --bootloader-id="$ID"
            if [ $? -eq 0 ]; then
                echo "GRUB installed successfully!"
                update-grub
            else
                echo "cannot install grub, try again"
                exit 1
            fi
        fi
}

arch() {
            pacman -S grub --needed --noconfirm
            grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id="$ID"
            if [ $? -eq 0 ]; then
                echo "GRUB installed successfully!"
                grub-mkconfig -o /boot/grub/grub.cfg
            else
                grub-install --target=x86_64-efi --efi-directory=/mnt/boot/efi --bootloader-id="$ID"
                if [ $? -eq 0 ]; then
                    echo "GRUB installed successfully!"
                    grub-mkconfig -o /boot/grub/grub.cfg
                else
                    echo "cannot install grub, try again"
                    exit 1
                fi
            fi  
}
fedora() {
        dnf install grub2-efi grub2-efi-modules shim -y
        grub2-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id="$ID"
        if [ $? -eq 0 ]; then
            echo "GRUB installed successfully!"
            grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg || grub2-mkconfig -o /boot/grub2/grub.cfg
        else
            grub2-install --target=x86_64-efi --efi-directory=/mnt/boot/efi --bootloader-id="$ID"
            if [ $? -eq 0 ]; then
                echo "GRUB installed successfully!"
                grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg || grub2-mkconfig -o /boot/grub2/grub.cfg
            else
                echo "cannot install grub, try again"
                exit 1
            fi        
        fi
}
if [[ "$ID_LIKE" == *debian* ]]; then
    debian
elif [[ "$ID_LIKE" == *arch* ]]; then
    arch
elif [[ "$ID_LIKE" == *fedora* ]]; then
    fedora
else
    echo "cannot install GRUB on your distro yet. try again later"
    exit 1
