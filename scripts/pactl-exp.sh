#!/bin/bash
# Change volume exponentially so that there are more steps closer to zero
# Currently not working
set -e

LEFT=$(pactl get-sink-volume @DEFAULT_SINK@ | cut -d " " -f 6 | sed 's/%//')
RIGHT=$(pactl get-sink-volume @DEFAULT_SINK@ | cut -d " " -f 16 | sed 's/%//')
SUM=$(($LEFT + $RIGHT))
AVERAGE=$(expr $SUM / 2)
LOG=$(echo "l($AVERAGE)" | bc -l)
SCALED=$((5 * $LOG))
PERCENTAGE=${SCALED:0:1}
if ["$PERCENTAGE" == "0"]; then
    PERCENTAGE="1"
fi

case $1 in
    inc) pactl set-sink-volume @DEFAULT_SINK@ "+$PERCENTAGE%";;
    dec) pactl set-sink-volume @DEFAULT_SINK@ "+$PERCENTAGE%";;
    *) echo "Invalid Argument: '$1'";;
esac
        
