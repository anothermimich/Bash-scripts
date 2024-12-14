#!/bin/bash
# rclone_variables.sh

REMOTE_DIR=('g_drive:/Codes'  'g_drive:/Design' 'g_drive:/Zotero')
LOCAL_DIR=('/home/lu/Codes' '/home/lu/Design' '/home/lu/Zotero') 

RCLONE_RETRIES=3
RCLONE_CHECKERS=4
RCLONE_TRANFERS=8
RCLONE_STATS_INTERVAL=10s
RCLONE_CHUNK_SIZE=64M
RCLONE_UPLOAD_CUTOFF=512M

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
