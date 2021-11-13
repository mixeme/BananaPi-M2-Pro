# BananaPi M2 Pro
This repository contains an intallation script for the Banana Pi M2 Pro SBC.

## Base image
Base image for this installation is
> 2021-06-21-debian-10-buster-bpi-m5-m2pro-aarch64-sd-emmc.img

from vendor [website](https://download.banana-pi.dev/d/ca025d76afd448aabc63/files/?p=%2FImages%2FBPI-M5%2Fdebian%2F2021-06-21-debian-10-buster-bpi-m5-m2pro-aarch64-sd-emmc.img.zip).

## What does script do?
1. Rename host to "BananaPi";
2. Upgrade system;
3. Make user `pi` as `sudo`;
4. Add another user (specify his name or comment it);
5. Install Banana Pi Tools;
6. Install Bluetooth Driver;
7. Install Network Manager (for manage Wi-Fi);
8. Install Desktop Environment (LXQt or XFCE). LightDM is configured to provide user list on logon screen and autologin for pi user;


9. Install Wi-Fi & Bluetooth utils (Network Manager Gnome and Blueman);
10. Install and configure VNC (TigerVNC) for :0 (physical) and :1 (pi) displays;
11. Install other userful apps (comment unnecessary or add your favorite);
12. Make some system changes;
	+ Add user `pi` to group `bluetooth`;
	+ Change HDMI mode to 720p;
	+ Enable Network Manager for managing network adapters
13. Reboot.

	Desktop is LightDM (displat manager) + xfwm (window mananger) + LXQt/XFCE;
	

