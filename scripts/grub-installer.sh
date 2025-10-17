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
if [ -f "$OS_INFO" ]; then
    . "$OS_INFO"
        if [[ "$ID_LIKE" == *debian* ]]; then
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
                fi
            fi
        elif [[ "$ID_LIKE" == *arch* ]]; then
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
                fi
            fi

        elif [[ "$ID_LIKE" == *fedora* ]]; then
            dnf install grub2-efi grub2-efi-modules shim -y
            grub2-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id="$ID"
            if [ $? -eq 0 ]; then
                echo "GRUB installed successfully!"
                grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg || grub2-mkconfig -o /boot/grub2/grub.cfg
            else
                grub-install --target=x86_64-efi --efi-directory=/mnt/boot/efi --bootloader-id="$ID"
                if [ $? -eq 0 ]; then
                    echo "GRUB installed successfully!"
                    grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg || grub2-mkconfig -o /boot/grub2/grub.cfg
                else
                    echo "cannot install grub, try again"
                fi
            fi
        else
            echo "this distro is not supported currently"
            exit 1
        fi
fi




