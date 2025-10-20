#!/bin/bash
#to use this scrtipt, at first find the partition you want to chroot
#use this script with root access!!
#this script only works on UEFI systems
#created by Abolfaz09
#use this script if you're usuing a live-linux


#checking /mnt
if mountpoint -q /mnt; then
    umount -R /mnt
    if [ $? -ne 0 ]; then
        echo "'/mnt' is mounted! unmount it and try again!"
        exit 1
    fi
fi   

#mounting the Linux root parition
lsblk
echo "Enter your Linux partiton full-name(enter carefully)"
echo "(example: /dev/nvme0n1p4): "
read TARGET
mount $TARGET /mnt
if [ $? -ne 0 ]; then
    echo "cannot mount the partition"
    exit 1
fi
#checking Linux installation
TEST="/mnt/etc/fstab"
if [ -f "$TEST" ]; then
    echo "a Linux system found on $TARGET"
else
    echo "looks partition has no any installed Linux! try again and choose the right partition."
    exit 1
fi
mnt() {
mount --bind /dev /mnt/dev
mount --bind /dev/pts /mnt/dev/pts
mount --bind /run /mnt/run
mount --bind /proc /mnt/proc
mount --bind /sys /mnt/sys
}
mnt
if [ ! -f ./grub-installer.sh ]; then
    echo "grub-installer.sh not found!"
    exit 1
fi

chroot /mnt /bin/bash -s < ./grub-installer.sh