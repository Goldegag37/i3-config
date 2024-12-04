#!/bin/bash

ACTION=$1
AMOUNT=$2
DEFAULT_SINK=$(pactl info | grep "Default Sink" | awk '{print $3}')

if [ -z "$DEFAULT_SINK" ]; then
    echo "No Output Found."
    exit 1
fi
if [ -z "$AMOUNT" ]; then
    AMOUNT=5
fi

case $ACTION in
    up)
        pactl set-sink-volume "$DEFAULT_SINK" +"$AMOUNT"%
        ;;
    down)
        pactl set-sink-volume "$DEFAULT_SINK" -"$AMOUNT"%
        ;;
    mute)
        pactl set-sink-mute "$DEFAULT_SINK" toggle
        ;;
    display)
        ;;
    *)
        echo "Usage: $0 [up|down|mute] <amount>"
        exit 1
        ;;
esac

CURRENT_VOLUME=$(pactl list sinks | grep -A 15 "$DEFAULT_SINK" | grep 'Volume:' | head -n 1 | awk '{print $5}' | tr -d '%')
IS_MUTED=$(pactl list sinks | grep -A 15 "$DEFAULT_SINK" | grep 'Mute:' | awk '{print $2}')

SINK_DESCRIPTION=$(pactl list sinks | grep -A 15 "$DEFAULT_SINK" | grep "Description:" | awk -F': ' '{print $2}')
if [[ "$SINK_DESCRIPTION" == *"bluetooth"* ]] || [[ "$SINK_DESCRIPTION" == *"F8"* ]]; then
    ICON="" # bt
elif [[ "$SINK_DESCRIPTION" == *"headphone"* ]]; then
    ICON="" # headphones
else
    if [ "$CURRENT_VOLUME" -ge 50 ]; then
        ICON="" # three lines speaker
    elif [ "$CURRENT_VOLUME" -ge 30 ]; then
        ICON="" # one lines speaker
    else
        ICON="" # no lines speaker
    fi
fi

CURRENT_VOLUME="$CURRENT_VOLUME%"

TEXT=" "

[ "$IS_MUTED" == "yes" ] && CURRENT_VOLUME=Muted


echo "$ICON$TEXT$CURRENT_VOLUME"
