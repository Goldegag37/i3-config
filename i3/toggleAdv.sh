#!/bin/bash

# Define the toggle file
TOGGLE_FILE="/tmp/i3.adv"

# Check if the file exists
if [ -f "$TOGGLE_FILE" ]; then
    # File exists, delete it
    rm "$TOGGLE_FILE"
    i3-msg -t command restart
    # feh --bg-scale ~/.config/i3/wall.png
else
    # File does not exist, create it
    touch "$TOGGLE_FILE"
    i3-msg -t command restart
    # feh --bg-scale ~/.config/i3/wall.adv.png
fi
