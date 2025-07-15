#!/bin/bash

LOCK="/tmp/low_battery_alert.lock"
SOUND_FILE="$HOME/.local/share/battery_alert/low_battery_3.mp3"

#low_battery_1.mp3
#low_battery_2.mp3
#low_battery_3.mp3

while true; do
    capacity=$(cat /sys/class/power_supply/BATC/capacity)
    status=$(cat /sys/class/power_supply/BATC/status)

    if [ "$capacity" -lt 20 ] && [ "$status" = "Discharging" ]; then
        if [ ! -f "$LOCK" ]; then
	volume_before=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}')
	pactl set-sink-volume @DEFAULT_SINK@ 40%
            paplay $SOUND_FILE
            touch "$LOCK"
	    pactl set-sink-volume @DEFAULT_SINK@ "$volume_before"
        fi
    else
        rm -f "$LOCK"
    fi

    sleep 180 
done

