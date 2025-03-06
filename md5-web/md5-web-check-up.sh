#!/bin/bash

source "$(dirname "$0")/md5-web-variables.sh"

echo 
echo "--- MD5 Check ---"
echo 

for ((i = 0 ; i < "${#URL[@]}"; i++)); do
	curl --silent ${URL[i]} | md5sum > check${i}.md5new

	if ! cmp check${i}.md5 check${i}.md5new > /dev/null; then
		echo "Go check ${URL[i]}" | mail -s "Change detected - MD5 Check " lu.immich@gmail.com
		echo "Go check ${URL[i]}" | mail -s "Change detected - MD5 Check " alinedalpont68@gmail.com
		echo -e "Go check ${URL[i]}" 
		mv check${i}.md5new check${i}.md5
	else
		echo -e "No changes detected in ${URL[i]}"
	fi
rm check${i}.md5new
done
