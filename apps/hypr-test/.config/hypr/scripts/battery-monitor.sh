#!/usr/bin/env bash

LOW_BATTERY=20
CRITICAL_BATTERY=10
WARNED_LOW=0
WARNED_CRITICAL=0

while true; do
    BATTERY=$(cat /sys/class/power_supply/BAT*/capacity | head -n1)
    STATUS=$(cat /sys/class/power_supply/BAT*/status | head -n1)

    if [[ "$STATUS" != "Charging" ]]; then

        if [[ "$BATTERY" -le "$CRITICAL_BATTERY" && "$WARNED_CRITICAL" -eq 0 ]]; then
            notify-send \
                -u critical \
                -a "Battery Monitor" \
                "🔴 Critical Battery" \
                "Battery is at ${BATTERY}%! Connect charger immediately."

            WARNED_CRITICAL=1

        elif [[ "$BATTERY" -le "$LOW_BATTERY" && "$WARNED_LOW" -eq 0 ]]; then
            notify-send \
                -u normal \
                -a "Battery Monitor" \
                "🟡 Low Battery" \
                "Battery is at ${BATTERY}%."

            WARNED_LOW=1
        fi

    else
        WARNED_LOW=0
        WARNED_CRITICAL=0
    fi

    sleep 60
done
