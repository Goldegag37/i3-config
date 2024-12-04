#!/bin/bash

# Specify the partition or drive to monitor
PARTITION="/"

# Get available disk space in bytes and strip the header
AVAILABLE=$(df --output=avail --block-size=1 "$PARTITION" | tail -n +2 | tr -d '[:space:]')

# Ensure AVAILABLE is a valid number
if ! [[ "$AVAILABLE" =~ ^[0-9]+$ ]]; then
    echo "Error: Unable to fetch disk space."
    exit 1
fi
echo -n " "
# Convert bytes into human-readable format with decimal precision
if [ "$AVAILABLE" -ge 1073741824 ]; then
    printf "%.2f GB\n" "$(echo "$AVAILABLE / 1073741824" | bc -l)"
elif [ "$AVAILABLE" -ge 1048576 ]; then
    printf "%.2f MB\n" "$(echo "$AVAILABLE / 1048576" | bc -l)"
else
    printf "%.2f KB\n" "$(echo "$AVAILABLE / 1024" | bc -l)"
fi