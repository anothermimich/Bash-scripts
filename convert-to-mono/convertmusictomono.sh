#!/bin/bash

# Target directory (defaults to current directory if no argument is provided)
TARGET_DIR="${1:-.}"

echo "Scanning '$TARGET_DIR' for audio files to convert to mono..."

find "$TARGET_DIR" -type f \( -iname \*.mp3 -o -iname \*.m4a -o -iname \*.flac \) -print0 | while IFS= read -r -d $'\0' file; do
    
    # 1. Check how many audio channels the file has
    channels=$(ffprobe -v error -select_streams a:0 -show_entries stream=channels -of default=noprint_wrappers=1:nokey=1 "$file")
    
    # 2. Skip if it is already mono
    if [ "$channels" -eq 1 ]; then
        echo "Skipping (already mono): $file"
        continue
    fi

    dir=$(dirname "$file")
    base=$(basename "$file")
    temp="$dir/temp_$base"
    
    echo "Converting to mono with max quality: $file"
    
    # 3. Convert preserving max quality (-q:a 0)
    if ffmpeg -nostdin -y -v error -stats -i "$file" -ac 1 -max_muxing_queue_size 9999 -q:a 0 "$temp"; then
        # Overwrite original on success
        mv "$temp" "$file"
    else
        echo "Failed to convert: $file"
        # Clean up the broken temp file on failure
        rm -f "$temp"
    fi
done

echo "Finished scanning and converting!"
