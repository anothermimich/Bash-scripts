#!/bin/bash

status_file="/home/lu/Codes/Bash-scripts/wacom-x11/status"
device_name="Wacom One by Wacom S Pen stylus"

# Verifica se o dispositivo está conectado
if xsetwacom --list devices | grep -q "$device_name"; then
  # Se o status for 0, configura e marca como feito
  if [[ $(cat "$status_file") -eq 0 ]]; then
    xsetwacom --set "$device_name" Button 2 "pan"
    xsetwacom --set "$device_name" "PanScrollThreshold" 200
    xsetwacom --set "$device_name" "Rotate" half
    echo 1 > "$status_file"
  fi
else
  # Se desconectado, resetar status
  echo 0 > "$status_file"
fi

