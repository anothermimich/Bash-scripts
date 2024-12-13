#!/bin/bash
# rclone_push.sh

source "$(dirname "$0")/rclone_variables.sh"

# Made by Lu Immich a.k.a https://github.com/anothermimich
#
# Based on markuscraig/sync_gdrive.py and on Faris Khasawneh scripts

echo "$(date +'%Y/%m/%d %H:%M:%S') Push started" >> "$HOME/.config/rclone/rclone.log"
echo "\n"
echo "--- Google Drive Push ---"
echo "\n"
echo "Local ---> Remote"
echo "Push will start in 10s"
echo "Press CTRL + C to abbort"
sleep 10
echo "Push started"

if  [[  "${#LOCAL_DIR[@]}" == "${#REMOTE_DIR[@]}" ]]; then
  for ((i = 0 ; i < "${#REMOTE_DIR[@]}"; i++)); do
    echo "$(date +'%Y/%m/%d %H:%M:%S') Remote --> Local, entry  ${i}" >> "$HOME/.config/rclone/rclone.log"

    rclone sync \
      "${LOCAL_DIR[i]}" "${REMOTE_DIR[i]}" \
      --compare-dest size,modtime,checksum \
      --modify-window 1s \
      --drive-acknowledge-abuse \
      --drive-skip-gdocs \
      --drive-skip-shortcuts \
      --drive-skip-dangling-shortcuts \
      --log-file "$HOME/.config/rclone/rclone.log" \
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
      --update 

    sleep 5

    if [ $? -eq 0 ]; then
      echo "$(date +'%Y/%m/%d %H:%M:%S') Push done, entry ${i}" >> "$HOME/.config/rclone/rclone.log"
      echo "\n"
      echo "Push done, entry ${i}"
    else
      echo "$(date +'%Y/%m/%d %H:%M:%S') Push failed, entry  ${i}" >> "$HOME/.config/rclone/rclone.log"
      echo "\n"
      echo "Push failed, entry ${i}"
      echo "Look at the log for more details"
    fi
  done
else
  echo "$(date +'%Y/%m/%d %H:%M:%S') Sintax DIR error" >> "$HOME/.config/rclone/rclone.log"
  echo "\n"
  echo "Sintax DIR error"
  echo "Check the variables as it can be the problem" 
fi