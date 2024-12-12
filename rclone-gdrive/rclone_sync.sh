#!/bin/bash
# rclone_sync.sh

source "$(dirname "$0")/rclone_variables.sh"

# Made by Lu Immich a.k.a https://github.com/anothermimich
#
# Based on markuscraig/sync_gdrive.py and on Faris Khasawneh scripts

echo "$(date +'%Y/%m/%d %H:%M:%S') Sync started" >> "$HOME/.config/rclone/rclone.log"

if  [[  "${#LOCAL_DIR[@]}" == "${#REMOTE_DIR[@]}" ]]; then
  for ((i = 0 ; i < "${#REMOTE_DIR[@]}"; i++)); do
    rclone bisync \
      "${REMOTE_DIR[i]}" "${LOCAL_DIR[i]}" \
      --compare-dest size,modtime,checksum \
      --modify-window 1s \
      --drive-acknowledge-abuse \
      --drive-skip-gdocs \
      --drive-skip-shortcuts \
      --drive-skip-dangling-shortcuts \
      --metadata \
      --log-file "$HOME/.config/rclone/rclone.log" \
      --retries $RCLONE_RETRIES \
      --checkers $RCLONE_CHECKERS \
      --transfers $RCLONE_TRANFERS \
      --stats $RCLONE_STATS_INTERVAL \
      --drive-chunk-size $RCLONE_CHUNK_SIZE \
      --drive-upload-cutoff $RCLONE_UPLOAD_CUTOFF \
      --no-update-modtime \
      --check-access \
      --recover \
      --max-lock 2m \
      --resilient \
      --fix-case \
      --track-renames \
      --create-empty-src-dirs \
      --conflict-resolve newer

    sleep 5

    if [ $? -eq 0 ]; then
      echo "$(date +'%Y/%m/%d %H:%M:%S') Sync done, entry ${i}" >> "$HOME/.config/rclone/rclone.log"
    else
      echo "$(date +'%Y/%m/%d %H:%M:%S') Exiting, sync failed, entry  ${i}" >> "$HOME/.config/rclone/rclone.log"
      exit
    fi
  done
else
  echo "$(date +'%Y/%m/%d %H:%M:%S') Sintax dir error" >> "$HOME/.config/rclone/rclone.log"
fi