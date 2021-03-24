#!/bin/bash

SCRIPTPATH="$(cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P)"
DDCCTL="$SCRIPTPATH/ddcctl"
MAC_MODEL="$(sysctl hw.model | awk '{print $2}')"
DISPLAY_COUNT="$("$DDCCTL" 2> /dev/null | awk '/I: found .* external displays/ {print $3}')"
DISPLAYS=()

for ((i=1; i <= DISPLAY_COUNT ; i++)); do
  DISPLAYS+=("$("$DDCCTL" -d $i -i \? | grep "current: " | cut -d" " -f8 | sed 's/,//')")
done

echo "${DISPLAYS[@]}"

# If the displays are asleep, wake them up
caffeinate -u -t 1

for ((i=1; i <= DISPLAY_COUNT ; i++)); do
  if [ "$MAC_MODEL" == "MacBookPro15,2" ]; then
    if [ ${DISPLAYS[$i-1]} -ne 15 ]; then
      # Switch external display 1 to DisplayPort-1
      "$DDCCTL" -d $i -i 15
    fi
  elif [ "$MAC_MODEL" == "MacBookPro15,1" ]; then
    if [ ${DISPLAYS[$i-1]} -ne 17 ]; then
      # Switch external display 1 to HDMI-1
      "$DDCCTL" -d $i -i 17
    fi
  fi
done
