#!/bin/bash
# rclone_sync.sh

source "$(dirname "$0")/rclone_variables.sh"

# Made by Lu Immich a.k.a https://github.com/anothermimich
#
# Based on markuscraig/sync_gdrive.py and on Faris Khasawneh scripts
#
# A 64M chunk-size is used for performance purposes.
# Google recommends as large a chunk size as possible.
# Rclone will use the following amount of RAM at run-time
# (8MB chunks by default; not high enough)...
#
#    RAM = (chunk-size * num-transfers)
#
# So our command will use larger chunk sizes (more RAM)...
#
#    RAM = 0.5 GB = (64MB * 8 transfers)
#
# For more details... https://github.com/ncw/rclone/issues/397

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
      --check-access
    #  Don't work
    #  --recover \
    #  --resilient \
    #  --track-renames \
    #  --create-empty-src-dirs \
    #  --fix-case \
    #  --max-lock 2m \

    sleep 1

    if [ $? -eq 0 ]; then
      echo "$(date +'%Y/%m/%d %H:%M:%S') Sync done ${i}" >> "$HOME/.config/rclone/rclone.log"
    else
      echo "$(date +'%Y/%m/%d %H:%M:%S') Sync failed  ${i}" >> "$HOME/.config/rclone/rclone.log"
    fi
  done
else
  echo "$(date +'%Y/%m/%d %H:%M:%S') Sintax error" >> "$HOME/.config/rclone/rclone.log"
fi