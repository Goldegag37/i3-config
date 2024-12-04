#!/bin/bash

BATTERY_PATH=$(upower -e | grep 'battery_BAT0')

if [ -z "$BATTERY_PATH" ]; then
    echo " NAN% (Time left: NAN)"
    exit 1
fi

STATUS=$(upower -i "$BATTERY_PATH" | grep -i 'state' | awk '{print $2}')

CHARGE=$(upower -i "$BATTERY_PATH" | grep -i 'percentage' | awk '{print $2}' | tr -d '%')

TIME_LEFT="Unknown"
TIME_TO_FULL="Unknown"

if [ "$STATUS" == "discharging" ]; then
    TIME_LEFT=$(upower -i "$BATTERY_PATH" | grep -i 'time to empty' | awk '{print $4, $5}')
    if [ -z "$TIME_LEFT" ]; then
        TIME_LEFT="Unknown"
    fi
elif [ "$STATUS" == "charging" ]; then
    TIME_TO_FULL=$(upower -i "$BATTERY_PATH" | grep -i 'time to full' | awk '{print $4, $5}')
    if [ -z "$TIME_TO_FULL" ]; then
        TIME_TO_FULL="Unknown"
    fi
fi

# CHARGE=5

tilFull="Til full:"
tilDead="Til dead:"

if [[ "$STATUS" == "charging" ]]; then
    if [[ "$CHARGE" -ge 80 ]]; then
        echo " ${CHARGE}% ($tilFull $TIME_TO_FULL)"
    elif [[ "$CHARGE" -ge 60 ]]; then
        echo " ${CHARGE}% ($tilFull $TIME_TO_FULL)"
    elif [[ "$CHARGE" -ge 40 ]]; then
        echo " ${CHARGE}% ($tilFull $TIME_TO_FULL)"
    elif [[ "$CHARGE" -ge 20 ]]; then
        echo " ${CHARGE}% ($tilFull $TIME_TO_FULL)"
    else
        echo " ${CHARGE}% ($tilFull $TIME_TO_FULL)"
    fi
elif [[ "$STATUS" == "discharging" ]]; then
    if [[ "$CHARGE" -ge 80 ]]; then
        echo " ${CHARGE}% ($tilDead $TIME_LEFT)"
    elif [[ "$CHARGE" -ge 60 ]]; then
        echo " ${CHARGE}% ($tilDead $TIME_LEFT)"
    elif [[ "$CHARGE" -ge 40 ]]; then
        echo " ${CHARGE}% ($tilDead $TIME_LEFT)"
    elif [[ "$CHARGE" -ge 21 ]]; then
        echo " ${CHARGE}% ($tilDead $TIME_LEFT)"
    else
        echo " ${CHARGE}% ($tilDead $TIME_LEFT)"
        
        if [[ "$CHARGE" -le 5 ]]; then
            if ! grep -q "5" /tmp/batLvlWarn; then
                notify-send -u critical "Battery under 5%, Charge it. Now."
                echo "5" > /tmp/batLvlWarn
            fi
        elif [[ "$CHARGE" -le 10 ]]; then
            if ! grep -q "10" /tmp/batLvlWarn; then
                notify-send -u critical "Battery under 10%, Charge it."
                echo "10" > /tmp/batLvlWarn
            fi
        elif [[ "$CHARGE" -le 20 ]]; then
            if ! grep -q "20" /tmp/batLvlWarn; then
                notify-send "Battery under 20%, Please Charge it."
                echo "20" > /tmp/batLvlWarn
            fi
        fi
    fi
else
    # Reset the warning file only when charging or battery is at a safe level
    if [[ "$CHARGE" -ge 20 || "$STATUS" == "charging" ]]; then
        echo > /tmp/batLvlWarn
    fi

    echo "Battery: ${CHARGE}% (Status: $STATUS)"
fi
