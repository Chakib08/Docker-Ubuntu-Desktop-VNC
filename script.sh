#!/bin/bash

# Export utilities
export XDG_SESSION_TYPE=x11
export XDG_CURRENT_DESKTOP=ubuntu:GNOME
export DISPLAY=:1
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus

locale-gen en_US.UTF-8
update-locale LANG=en_US.UTF-8

# Configure SSH
echo "PermitRootLogin yes" | tee -a /etc/ssh/sshd_config

# Start SSH service
service ssh start

# Compile schemas for desktop sharing
glib-compile-schemas /usr/share/glib-2.0/schemas

# Create startup application for Vino server
mkdir -p ~/.config/autostart
cat > ~/.config/autostart/vino-server.desktop <<EOF
[Desktop Entry]
Type=Application
Exec=/usr/lib/vino/vino-server
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_US]=VNC
Name=VNC
Comment[en_US]=VNC Vino
Comment=VNC Vino
EOF

# Configure Desktop sharing
cp /org.gnome.Vino.gschema.xml /usr/share/glib-2.0/schemas/org.gnome.Vino.gschema.xml

# Set environment variables for GNOME
Xvfb :1 -screen 0 1280x1024x24 &

# Ensure dbus is running
service dbus start
echo "Ensure dbus is running"

mkdir -p /run/user/1000 &&     
dbus-daemon --session --address=unix:path=/run/user/1000/bus --fork

# Enable screen sharing
dconf write /org/gnome/desktop/remote-access/enabled true
dconf write /org/gnome/desktop/remote-access/vnc-password "'$(echo -n $VNC_PASSWORD | base64)'"

# Disable encryption and prompts
gsettings set org.gnome.Vino require-encryption false
gsettings set org.gnome.Vino prompt-enabled false

# Start GNOME session and Vino server
echo "Starting GNOME session and Vino server...."
/usr/lib/vino/vino-server &
gnome-session &

wait
