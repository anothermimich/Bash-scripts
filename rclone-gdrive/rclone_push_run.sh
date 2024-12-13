#!/bin/bash
# rclone_push_run.sh

if ! "$(dirname "$0")/rclone_check_metered.sh"
then
    echo "$(date +'%Y/%m/%d %H:%M:%S') rclone_timer triggered" >> "$HOME/.config/rclone/rclone.log"
    "$(dirname "$0")/rclone_push.sh"
fi