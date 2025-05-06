#!/bin/bash

if  [[  $(xsetwacom --list devices | grep -c "Wacom One by Wacom S Pen stylus 	id: 9	type: STYLUS") == 1 ]]; then
  xsetwacom --set "Wacom One by Wacom S Pen stylus" Button 2 "pan"
  xsetwacom --set "Wacom One by Wacom S Pen stylus" "PanScrollThreshold" 200
  xsetwacom --set "Wacom One by Wacom S Pen stylus" "Rotate" half
fi