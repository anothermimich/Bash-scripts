#!/bin/bash
for file in *.JPG *.jpg *.jpeg *.png; do
  [ -f "$file" ] || continue  # skip if not a regular file
  filename="${file%.*}"
  convert "$file" -resize 1080x1080\> "${filename}.webp"
done
