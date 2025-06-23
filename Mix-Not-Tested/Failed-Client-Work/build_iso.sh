#!/bin/bash

SOURCE_ISO="ubuntu-22.04.4-live-server-amd64.iso"
CUSTOM_ISO="custom-ubuntu-22.04-mirth.iso"
WORK_DIR="iso_work"
MOUNT_DIR="iso_mount"

# Install required tools
sudo apt update
sudo apt install -y wget xorriso isolinux cloud-image-utils

# Create directories
mkdir -p $WORK_DIR $MOUNT_DIR

# Download Ubuntu ISO
wget https://releases.ubuntu.com/22.04.4/ubuntu-22.04.4-live-server-amd64.iso

# Mount source ISO
sudo mount -o loop $SOURCE_ISO $MOUNT_DIR
rsync -av $MOUNT_DIR/ $WORK_DIR/
sudo umount $MOUNT_DIR

# Add autoinstall configs
mkdir -p $WORK_DIR/server
cp user-data meta-data $WORK_DIR/server/

# Add postinstall script
mkdir -p $WORK_DIR/postinstall
cp setup.sh $WORK_DIR/postinstall/

# Configure boot menu
sed -i 's/default install/default autoinstall/' $WORK_DIR/isolinux/txt.cfg
sed -i '/label install/i \
label autoinstall\n\
  menu label ^Autoinstall Mirth Server\n\
  kernel /casper/vmlinuz\n\
  append initrd=/casper/initrd autoinstall ds=nocloud\\;s=/cdrom/server/ quiet ---' $WORK_DIR/isolinux/txt.cfg

# Build new ISO
xorriso -as mkisofs -r \
  -V "Mirth Ubuntu Server" \
  -o $CUSTOM_ISO \
  -J -l -b isolinux/isolinux.bin \
  -c isolinux/boot.cat -no-emul-boot \
  -boot-load-size 4 -boot-info-table \
  -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot \
  $WORK_DIR

# Cleanup
rm -rf $WORK_DIR $MOUNT_DIR
echo "Custom ISO created: $CUSTOM_ISO"