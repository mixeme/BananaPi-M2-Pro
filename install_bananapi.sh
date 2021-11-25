#! /bin/bash

# Base image is Debian Buster with kernel 4.9.241:
# 2021-06-21-debian-10-buster-bpi-m5-m2pro-aarch64-sd-emmc.img
#
# Download it from:
# https://wiki.banana-pi.org/Banana_Pi_BPI-M5#Debian
#
# Default login credentials:
# root - bananapi; pi/bananapi.

# Check input arguments
if [[ $# -ne 1 ]];
then
	echo "Input desired desktop: lxqt or xfce"
	exit 0
else
	case $1 in
		"lxqt" | "xfce" )
		;;
		* )
			echo "Unknown desktop!"
			exit 0
		;;
	esac
fi

# Set work directory in place of the installation script
	cd $(dirname $0)

# Variables
	HOSTNAME=BananaPi

# Host rename
	hostnamectl set-hostname $HOSTNAME

# System update
	echo "===== Start system update. ====="
	apt update -y
	apt upgrade -y
	echo "===== System is updated. ====="

# Operations with users
	apt install -y sudo
	usermod -aG sudo pi
	echo "===== User pi is sudo now. ====="

	# User another user
	adduser myuser --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
	chpasswd <<< "myuser:password"
	usermod -aG netdev,bluetooth myuser

# Software installation
## Banana Pi utils
	apt install -y pv curl

	mkdir ./bpi-tools
	cd ./bpi-tools
	curl -sL https://github.com/BPI-SINOVOIP/bpi-tools/raw/master/bpi-tools | sudo -E bash
	cd ..
	rm -R ./bpi-tools

	echo "===== BPI-Tools is installed. ====="

## Bluetooth Driver
	apt install -y make gcc git bluez bluez-tools bluetooth rfkill

	git clone https://github.com/Dangku/rtk-linux-bt-driver.git
	cd ./rtk-linux-bt-driver
	make install INTERFACE=usb
	cd ..
	rm -R ./rtk-linux-bt-driver

	echo "===== Bluetooth Driver is installed. ====="

## Wi-Fi manager
	apt install -y network-manager

## Desktop Environment
	echo "===== Start installation of Desktop Environment. ====="
	### X Server
	apt install -y --no-install-recommends xserver-xorg-core xserver-xorg-input-libinput xinit dbus-x11 xfonts-base x11-xserver-utils x11-utils libgl1-mesa-dri mesa-utils mesa-utils-extra

	### Display Manager
	apt install -y lightdm
	cp ./lightdm/10_userlist.conf	/usr/share/lightdm/lightdm.conf.d/
	cp ./lightdm/11_autologin.conf	/usr/share/lightdm/lightdm.conf.d/

	### Some preferred apps
	apt install	-y xarchiver upower

	case $1 in
		"xfce" )
		### XFCE Desktop
			apt install -y xfce4 xfce4-terminal thunar-archive-plugin
			TRANSMISSION=transmission
		;;
		"lxqt" )
		### LXQt Desktop
			apt install -y --no-install-recommends lxqt feathernotes qpdfview speedcrunch
			apt install -y lxqt-themes xfwm4-theme-breeze
			TRANSMISSION=transmission-qt
		;;
	esac

	apt install -y gvfs gvfs-fuse gvfs-backends

### Manage operations for non-root users
	apt install	-y policykit-1

### Icon themes
	apt install -y gnome-icon-theme papirus-icon-theme tango-icon-theme

	echo "===== Desktop Environment is installed. ====="

## Wi-Fi & Bluetooth utils
	apt install -y network-manager-gnome blueman

## VNC
	echo "===== Start installation of VNC server. ====="
### Install packages
	apt install -y tigervnc-scraping-server tigervnc-standalone-server tigervnc-xorg-extension

### Allow remote connections
	echo "\$localhost = \"no\";" >> /etc/vnc.conf

### Copy files
	cp ./vnc/x0vnc.sh 				/usr/local/bin/
	cp ./vnc/x0vncserver.service 	/etc/systemd/system/
	cp ./vnc/vncserver@.service 	/etc/systemd/system/

	# Profile example
	mkdir /etc/vnc
	cp ./vnc/profile.env			/etc/vnc/pi.env

### Set password fo user pi
	PI_HOME=$(echo ~pi)

	mkdir "$PI_HOME/.vnc"
	vncpasswd -f <<< "bananapi" > "$PI_HOME/.vnc/passwd"
	chown -R pi:pi $PI_HOME/.vnc
	chmod 600 $PI_HOME/.vnc/passwd

### Enable service
	chmod +x /usr/local/bin/x0vnc.sh

	systemctl enable x0vncserver.service
	systemctl enable vncserver@pi.service

	echo "===== VNC server is installed. ====="

## Other apps
	apt install -y timeshift
	apt install -y f2fs-tools btrfs-progs
	apt install -y ntfs-3g exfat-fuse exfat-utils
	apt install -y htop autofs bindfs autossh ufw acl
	apt install -y samba cifs-utils minidlna $TRANSMISSION
	apt install -y gnome-disk-utility gparted baobab galternatives
	apt install -y gedit gedit-plugin-draw-spaces gedit-plugin-word-completion
	apt install -y firefox-esr
	apt install -y libreoffice
	apt install -y system-config-printer

# Change system configs
	## Add users to groups
	usermod -aG bluetooth pi

	## Change HDMI to 720p
	sed -i "s/setenv hdmimode \"1080p60hz\"/setenv hdmimode \"720p60hz\"/"  /boot/firmware/boot.ini

	## Enable Network Manager
	sed -i "s/managed=false/managed=true/" /etc/NetworkManager/NetworkManager.conf

	## Rename MiniDLNA host and enable automatic discovery
	sed -i "s/#friendly_name=/friendly_name=$HOSTNAME/" /etc/minidlna.conf
	sed -i "s/#inotify=yes/inotify=yes/" /etc/minidlna.conf

# Reboot system
	reboot
