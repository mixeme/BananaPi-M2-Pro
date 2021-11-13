# BananaPi M2 Pro
This repository contains my personal intallation script for the Banana Pi M2 Pro SBC.

Motivation: tha base Debian image is extremely minimal and requires many steps to make system usable.

## Base image
The base image for this installation is Debian 10 (Buster) with kernel 4.9

> 2021-06-21-debian-10-buster-bpi-m5-m2pro-aarch64-sd-emmc.img

from the vendor [website](https://wiki.banana-pi.org/Banana_Pi_BPI-M5#Debian).

## What does script do?
1. Rename host to "BananaPi";
2. Upgrade system;
3. Make user `pi` as `sudo`;
4. Add another user (specify his name or comment it);
5. Install Banana Pi Tools;
6. Install Bluetooth Driver;
7. Install Network Manager (for manage Wi-Fi);
8. Install Desktop Environment (LXQt or XFCE);
	+ Desktop is LightDM (display manager) + xfwm (window manager) + LXQt/XFCE;
	+ LightDM is configured to provide user list on logon screen (`lightdm/10_userlist.conf` file) and autologin for user `pi` (`lightdm/11_autologin.conf` file);
9. Install Wi-Fi & Bluetooth utils (Network Manager Gnome and Blueman);
10. Install and configure VNC server (TigerVNC) for `:0` (physical) and `:1` (for `pi`) displays;
11. Install other userful apps (comment unnecessary or add your favorite ones);
12. Make some system changes;
	+ Add user `pi` to group `bluetooth`;
	+ Change HDMI mode to 720p;
	+ Enable Network Manager for managing network adapters.
13. Reboot.

## How to
1. Download and flash the base image to SD card;
2. Copy repository contents to `/root/Install`;
3. Permit `root` login through SSH. Skip this step if you will use keyboard and monitor for the installation;
	Open `/etc/ssh/sshd_config` and change line with `PermitRootLogin` to

> PermitRootLogin yes



