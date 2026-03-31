#!/bin/bash

# Toggle secondary monitor (DP-2) on/off for focused work

MONITOR="DP-2"

if wlr-randr | grep -A6 "^$MONITOR" | grep -q "Enabled: yes"; then
    wlr-randr --output "$MONITOR" --off
    notify-send "Zen mode ON" "Monitor $MONITOR disabled" --icon=display
else
    wlr-randr --output "$MONITOR" --on
    notify-send "Zen mode OFF" "Monitor $MONITOR enabled" --icon=display
fi
