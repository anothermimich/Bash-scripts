#!/bin/bash
# rclone_pull.sh

source "$(dirname "$0")/rclone_variables.sh"

# Made by Lu Immich a.k.a https://github.com/anothermimich
#
# Based on markuscraig/sync_gdrive.py and on Faris Khasawneh scripts

echo "$(date +'%Y/%m/%d %H:%M:%S') Pull started" >> "$HOME/.config/rclone/rclone.log"
echo 
echo "--- Google Drive Pull ---"
echo 
echo "Remote --> Local"
echo "Pull will start in 10s"
echo "Press CTRL + C to abbort"
sleep 10
echo 
echo "Pull started"

if  [[  "${#LOCAL_DIR[@]}" == "${#REMOTE_DIR[@]}" ]]; then
  for ((i = 0 ; i < "${#REMOTE_DIR[@]}"; i++)); do
    echo "$(date +'%Y/%m/%d %H:%M:%S') Local --> Remote, entry  ${i}" >> "$HOME/.config/rclone/rclone.log"
    echo

    rclone sync \
      "${REMOTE_DIR[i]}" "${LOCAL_DIR[i]}" \
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
      --update \
      --progress

    sleep 5

    if [ $? -eq 0 ]; then
      echo "$(date +'%Y/%m/%d %H:%M:%S') Pull done, ${REMOTE_DIR[i]} to ${LOCAL_DIR[i]}" >> "$HOME/.config/rclone/rclone.log"
      echo 
      echo -e "Pull ${GREEN}done${NC}, ${REMOTE_DIR[i]} to ${LOCAL_DIR[i]}"
    else
      echo "$(date +'%Y/%m/%d %H:%M:%S') Pull failed, ${REMOTE_DIR[i]} to ${LOCAL_DIR[i]}" >> "$HOME/.config/rclone/rclone.log"
      echo 
      echo -e "Pull ${RED}failed${NC}, ${REMOTE_DIR[i]} to ${LOCAL_DIR[i]}"
      echo "Look at the log for more details"
    fi
  done
else
  echo "$(date +'%Y/%m/%d %H:%M:%S') Sintax DIR error" >> "$HOME/.config/rclone/rclone.log"
  echo 
  echo  -e "${RED}Sintax DIR error"
  echo "Check the variables as it can be the problem" 
fi

echo 