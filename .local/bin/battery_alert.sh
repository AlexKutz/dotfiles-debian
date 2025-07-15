#!/bin/bash

LOCK="/tmp/low_battery_alert.lock"

while true; do
    capacity=$(cat /sys/class/power_supply/BATC/capacity)
    status=$(cat /sys/class/power_supply/BATC/status)

    if [ "$capacity" -lt 20 ] && [ "$status" = "Discharging" ]; then
        if [ ! -f "$LOCK" ]; then
	volume_before=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}')
	pactl set-sink-volume @DEFAULT_SINK@ 100%
            paplay /usr/share/sounds/freedesktop/stereo/dialog-warning.oga
            touch "$LOCK"
	    pactl set-sink-volume @DEFAULT_SINK@ "$volume_before"
        fi
    else
        rm -f "$LOCK"
    fi

    sleep 180 
done

