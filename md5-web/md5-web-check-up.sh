#!/bin/bash

source "$(dirname "$0")/md5-web-variables.sh"
source "$(dirname "$0")/md5-web-mail.sh"

echo 
echo "--- MD5 fingerprint ---"
echo 

for ((i = 0 ; i < "${#URL[@]}"; i++)); do
	if [ ! -f check${i}.md5 ]; then
		curl --silent ${URL[i]} | md5sum > check${i}.md5
		echo -e "Creating a new fingerprint for ${URL[i]}"
	else
		echo -e "Nothing to do"
	fi
done

echo 
echo "--- MD5 Check ---"
echo 

for ((i = 0 ; i < "${#URL[@]}"; i++)); do
	curl --silent "${URL[i]}?$(date +%s)" | md5sum > check${i}.md5new
	if ! cmp check${i}.md5 check${i}.md5new > /dev/null; then
		for ((c = 0 ; c < "${#MAIL[@]}"; c++)); do
			echo "Go check ${URL[i]}" | mail -s "Change detected - MD5 Check " ${MAIL[c]}
		done
		echo -e "Go check ${URL[i]}" 
		mv check${i}.md5new check${i}.md5
	else
		echo -e "No changes detected in ${URL[i]}"
		rm check${i}.md5new
	fi
done
