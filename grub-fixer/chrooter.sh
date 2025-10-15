#!/bin/bash
#to use this scrtipt, at first find the partition you want to chroot
#use this script with root access!!
#this script only works on UEFI systems
#created by Abolfaz09
#use this script if you're usuing a live-linux

#checking live-linux or not
#echo "are you using a live linux?(yes/no)"
#read ANSWER
#if [ "$ANSER" == yes ]; then
#   echo "Great! script will continue"
#elif [ "$ANSWER" == no ]; then
#    echo "use the 


#mounting the Linux root parition
echo "Enter your Linux partiton full-name(enter carefully)"
echo "(example: /dev/nvme0n1p4): "
read TARGET

mount $TARGET /mnt
mount --bind /dev /mnt/dev
mount --bind /dev/pts /mnt/dev/pts
mount --bind /run /mnt/run
mount --bind /proc /mnt/proc
mount --bind /sys /mnt/sys

chroot /mnt /bin/bash -s < ./grub-installer.sh





























































