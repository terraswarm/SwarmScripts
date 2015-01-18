#!/bin/bash

sudo su -c

# mount the original iso
mkdir -p /mnt/iso
mount -o loop ubuntu-14.04-server-amd64.iso /mnt/iso

# create a writable copy of the iso
rm -rf /opt/serveriso
mkdir -p /opt/serveriso
cp -rT /mnt/iso /opt/serveriso
chmod -R 777 /opt/serveriso

# edit for an unattended installation
cp ks.cfg /opt/serveriso
cd /opt/serveriso
echo en>isolinux/langlist
sed -i "s@quite --@ks=cdrom:/ks.cfg@g" /opt/serveriso/isolinux/txt.cfg

# create a new iso
sudo mkisofs -D -r -V "ATTENDLESS_UBUNTU" -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o /opt/autoinstall.iso /opt/serveriso
