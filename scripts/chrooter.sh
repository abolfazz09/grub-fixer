#!/bin/bash
#to use this scrtipt, at first find the partition you want to chroot
#use this script with root access!!
#this script only works on UEFI systems
#created by Abolfaz09
#use this script if you're usuing a live-linux

#mounting the Linux root parition
echo "Enter your Linux partiton full-name(enter carefully)"
echo "(example: /dev/nvme0n1p4): "
read TARGET
mount $TARGET /mnt
TEST="/mnt/etc/fstab"
if [ "$TARGET" -eq 0 ]; then
    :
else
    echo "this partition doesn't have any installed Linux"
    exit 1
fi

mount --bind /dev /mnt/dev
mount --bind /dev/pts /mnt/dev/pts
mount --bind /run /mnt/run
mount --bind /proc /mnt/proc
mount --bind /sys /mnt/sys

chroot /mnt /bin/bash -s < ./grub-installer.sh





























































