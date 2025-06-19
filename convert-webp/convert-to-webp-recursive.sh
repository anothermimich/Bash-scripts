#!/bin/bash
find . -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) | while read -r file; do
  dir=$(dirname "$file")
  name=$(basename "$file")
  filename="${name%.*}"
  convert "$file" -resize 1080x1080\> "${dir}/${filename}.webp"
done

