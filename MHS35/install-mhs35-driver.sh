#!/bin/bash

#CHECKS
# if [ -f /etc/X11/xorg.conf.d/40-libinput.conf ]; then
# # removes base touch configurations if any.
# 	sudo rm -rf /etc/X11/xorg.conf.d/40-libinput.conf
# fi

# if [ ! -d /etc/X11/xorg.conf.d ]; then
# # setups the folder for future installations of X11
# 	sudo mkdir -p /etc/X11/xorg.conf.d
# fi

#COPY OVERLAYS
#sudo cp ./MHS35/mhs35-overlay.dtb /boot/overlays/
sudo cp mhs35-overlay.dtbo /boot/overlays/

#CHECK /boot/firmware/config.txt or /boot/config.txt
configPath = /boot/firmware/config.txt
if [ -f /boot/firmware/config.txt ]; then
	configPath = /boot/firmware/config.txt
fi

#ADD configs
#pi hardware
#sudo echo "dtparam=i2c_arm=on" >> $configPath
#sudo echo "enable_uart=1" >> $configPath
sudo echo "dtparam=spi=on" >> "$configPath"
#hdmi enable and custom signal output
sudo echo "hdmi_force_hotplug=1" >> "$configPath"
sudo echo "hdmi_mode=1" >> "$configPath"
sudo echo "hdmi_mode=87" >> "$configPath"
sudo echo "hdmi_group=2" >> "$configPath"
sudo echo "hdmi_cvt 480 320 60 6 0 0 0" >> "$configPath"
sudo echo "hdmi_drive=2" >> "$configPath"
#add the overlay and minimal config
sudo echo "dtoverlay=mhs35:rotate=270" >> "$configPath"

#COPY extra configs
#default rotation is 270 in 99-calibration.conf
#sudo cp -rf 99-calibration.conf  /etc/X11/xorg.conf.d/99-calibration.conf
#sudo cp -rf 99-fbturbo  /usr/share/X11/xorg.conf.d/99-fbturbo.conf
#sudo cp -rf 99-fbturbo-fbcp  /usr/share/X11/xorg.conf.d/99-fbturbo.conf
#sudo cp -rf rc.local /etc/rc.local
sudo cp -rf mhs35-fbcp.service /etc/systemd/system/mhs35-fbcp.service
#sudo cp -rf force-fb_ili9486.service /etc/systemd/system/force-fb_ili9486.service
#check if do i actually require this inittab.
#sudo cp inittab /etc/

#ADD extra module preconfigurations for kernel
#sudo echo "spi_bcm2835" >> /etc/modules
#sudo echo "fb_ili9486" >> /etc/modules


#INSTALL custom fbpc compiled for rpi0w
sudo install fbcp /usr/local/bin/fbcp

#INSTALL evdev to handle touch screen capabilities
#sudo apt-get install xserver-xorg-input-evdev -y

#MODIFY X11 touch init steps
#sudo cp -rf /usr/share/X11/xorg.conf.d/10-evdev.conf /usr/share/X11/xorg.conf.d/45-evdev.conf

#CONFIGURE systemd startup
sudo systemctl enable mhs35-fbcp.service
sudo systemctl start mhs35-fbcp.service
