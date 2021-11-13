#! /bin/bash

# Export environment variable for display manager
export XAUTHORITY="/var/run/lightdm/root/:0"

# Start VNC server for :0 in background
(/usr/bin/x0vncserver -display :0 -SecurityTypes None) &

#/usr/bin/X0tigervnc -display :0  -rfbauth $HOME/.vnc/passwd
#/usr/bin/x0tigervncserver -display :0  -rfbauth $HOME/.vnc/passwd

# Provide clean exit code
exit 0
