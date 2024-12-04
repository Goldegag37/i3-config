#!/bin/bash

# File to store the last volume level
VOLUME_FILE="/tmp/last_volume.txt"
MUTE_FILE="/tmp/mute_status.txt"

# Check if the mute status file exists
if [ -f "$MUTE_FILE" ]; then
    # If the mute status file exists, restore volume and unmute
    echo "Unmuting audio and restoring volume..."
    if [ -f "$VOLUME_FILE" ]; then
        LAST_VOLUME=$(cat "$VOLUME_FILE")
        echo "Restoring volume to: $LAST_VOLUME%"
        amixer -c 0 set 'PGA1.0 1 Master' "${LAST_VOLUME}%"
        rm "$VOLUME_FILE"  # Remove the volume file after restoring
    else
        echo "No previous volume level stored. Unmuting at 50%."
        amixer -c 0 set 'PGA1.0 1 Master' 50%
    fi
    rm "$MUTE_FILE"  # Remove the mute status file
else
    # Store the current volume and mute
    echo "Muting audio and storing current volume..."
    CURRENT_VOLUME=$(amixer -c 0 get 'PGA1.0 1 Master' | grep -oP '\[\d+%\]' | head -n 1)

    if [ -z "$CURRENT_VOLUME" ]; then
        echo "Failed to parse current volume."
        exit 1
    fi

    # Remove brackets and percent sign for storage
    CURRENT_VOLUME=${CURRENT_VOLUME//[%\[\]]/}
    echo "Storing volume as: $CURRENT_VOLUME"
    echo "$CURRENT_VOLUME" > "$VOLUME_FILE"

    # Create the mute status file to indicate audio is muted
    touch "$MUTE_FILE"

    # Mute the audio by setting the volume to 0%
    amixer -c 0 set 'PGA1.0 1 Master' 0%
fi

