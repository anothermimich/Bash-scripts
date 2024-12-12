#!/bin/bash
# rclone_sync_first_run.sh

source "$(dirname "$0")/rclone_variables.sh"

# Made by Lu Immich a.k.a https://github.com/anothermimich
#
# Based on markuscraig/sync_gdrive.py and on Faris Khasawneh scripts

echo "$(date +'%Y/%m/%d %H:%M:%S') First sync started"

if  [[  "${#LOCAL_DIR[@]}" == "${#REMOTE_DIR[@]}" ]]; then
  for ((i = 0 ; i < "${#REMOTE_DIR[@]}"; i++)); do
   
    echo "$(date +'%Y/%m/%d %H:%M:%S') Remote --> Local, entry  ${i}" >> "$HOME/.config/rclone/rclone.log"

    rclone sync \
      "${REMOTE_DIR[i]}" "${LOCAL_DIR[i]}" \
      --compare-dest size,modtime,checksum \
      --modify-window 1s \
      --drive-acknowledge-abuse \
      --drive-skip-gdocs \
      --drive-skip-shortcuts \
      --drive-skip-dangling-shortcuts \
      --metadata \
      --retries $RCLONE_RETRIES \
      --checkers $RCLONE_CHECKERS \
      --transfers $RCLONE_TRANFERS \
      --stats $RCLONE_STATS_INTERVAL \
      --drive-chunk-size $RCLONE_CHUNK_SIZE \
      --drive-upload-cutoff $RCLONE_UPLOAD_CUTOFF \
      --no-update-modtime \
      --no-update-dir-modtime \
      --fix-case \
      --track-renames \
      --create-empty-src-dirs \
      --verbose

    sleep 1

    if [ $? -eq 0 ]; then
      echo "$(date +'%Y/%m/%d %H:%M:%S') First sync done, entry ${i}"
    else
      echo "$(date +'%Y/%m/%d %H:%M:%S') First sync failed, entry ${i}"
    fi
  done
else
  echo "$(date +'%Y/%m/%d %H:%M:%S') Sintax DIR error"
fi