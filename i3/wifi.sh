#!/bin/bash

# Get the SSID
SSID=$(iwgetid -r)

# Get the signal strength
SIGNAL=$(iwconfig 2>&1 | grep -oP 'Link Quality=\K[0-9]+')

# Get the IP address from the active Wi-Fi interface (e.g., wlp2s0 or wlan0)
IP=$(ip addr show wlan0 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)

if [ -z "$SSID" ]; then
    echo "Wi-Fi: Not connected"
else
    if [ -z "$IP" ]; then
        echo " $SSID ($SIGNAL%, Unassigned)"
    else
        echo " $SSID ($SIGNAL%, $IP)"
    fi
fi

