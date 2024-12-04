#!/bin/bash

BRIGHTNESS=$(brightnessctl -q g)   # Current brightness value
MAX_BRIGHTNESS=$(brightnessctl -q m)  # Maximum brightness value

if [ -z "$BRIGHTNESS" ] || [ -z "$MAX_BRIGHTNESS" ]; then
    echo "Could not retrieve brightness. Make sure brightnessctl is installed."
    exit 1
fi

PERCENTAGE=$(( BRIGHTNESS * 100 / MAX_BRIGHTNESS ))

echo " $PERCENTAGE%"
