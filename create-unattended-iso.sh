#!/bin/bash
# Reference
# [1] https://pricklytech.wordpress.com/2013/04/21/ubuntu-server-unattended-installation-custom-cd/
# [2] https://github.com/netson/ubuntu-unattended

# mount the original iso
case "$1" in
1) 	
	URL=http://releases.ubuntu.com/14.04/ubuntu-14.04-server-amd64.iso
	ISONAME=ubuntu-14.04-server-amd64.iso
	;;
*) 	
	URL=http://cdimage.ubuntu.com/ubuntustudio/releases/trusty/release/ubuntustudio-14.04.1-dvd-amd64.iso
	ISONAME=ubuntustudio-14.04.1-dvd-amd64.iso
	;;
esac
echo "URL = $URL"
echo "ISONAME = $ISONAME"
wget -nc $URL
sudo mkdir -p /mnt/iso
sudo umount /mnt/iso
sudo mount -o loop $ISONAME /mnt/iso

# create a writable copy of the iso
sudo rm -rf /opt/serveriso
sudo mkdir -p /opt/serveriso
sudo cp -rT /mnt/iso /opt/serveriso
sudo chmod -R 777 /opt/serveriso

# edit for an unattended installation
sudo cp ks.cfg /opt/serveriso
sudo echo en>/opt/serveriso/isolinux/langlist
case "$1" in 

1)	
	sudo sed -i 's/quiet\ --/ks=cdrom:\/ks.cfg/g' /opt/serveriso/isolinux/txt.cfg
	sudo cat extra.preseed >> /opt/serveriso/preseed/ubuntu-server.seed
	;;
*)	
	sudo sed -i 's/quiet\ splash\ --/ks=cdrom:\/ks.cfg/g' /opt/serveriso/isolinux/txt.cfg
	sudo cat extra.preseed >> /opt/serveriso/preseed/ubuntustudio.seed
	;;
esac

# create a new iso, which is at /opt/autoinstall.iso
cd /opt/serveriso
sudo mkisofs -D -r -V "ATTENDLESS_UBUNTU" -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o /opt/autoinstall.iso /opt/serveriso
cd -
