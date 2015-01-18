#!/bin/bash

# mount the original iso
wget -nc http://releases.ubuntu.com/14.04/ubuntu-14.04-server-amd64.iso 
sudo mkdir -p /mnt/iso
sudo umount /mnt/iso
sudo mount -o loop ubuntu-14.04-server-amd64.iso /mnt/iso

# create a writable copy of the iso
sudo rm -rf /opt/serveriso
sudo mkdir -p /opt/serveriso
sudo cp -rT /mnt/iso /opt/serveriso
sudo chmod -R 777 /opt/serveriso

# edit for an unattended installation
sudo cp ks.cfg /opt/serveriso
sudo echo en>/opt/serveriso/isolinux/langlist
sudo sed -i "s@quite --@ks=cdrom:/ks.cfg@g" /opt/serveriso/isolinux/txt.cfg
sudo cat extra.preseed >> /opt/serveriso/preseed/ubuntu-server.seed
sudo cat extra.preseed >> /opt/serveriso/preseed/ubuntu-server-minimal.seed

# create a new iso
cd /opt/serveriso
sudo mkisofs -D -r -V "ATTENDLESS_UBUNTU" -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o /opt/autoinstall.iso /opt/serveriso
cd -
