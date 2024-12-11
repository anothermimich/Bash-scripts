#!/bin/bash
# rclone_variables.sh

REMOTE_DIR=('g_drive:/Codes'  'g_drive:/Design')
LOCAL_DIR=('/home/lu/Codes' '/home/lu/Design') 
RCLONE_RETRIES=3
RCLONE_CHECKERS=4
RCLONE_TRANFERS=8
RCLONE_STATS_INTERVAL=10s
RCLONE_CHUNK_SIZE=64M
RCLONE_UPLOAD_CUTOFF=512M