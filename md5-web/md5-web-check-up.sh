#!/bin/bash

source "$(dirname "$0")/md5-web-variables.sh"
source "$(dirname "$0")/md5-web-mail.sh"

echo 
echo "--- MD5 fingerprint ---"
echo 

# No cache

for ((i = 0 ; i < "${#URL[@]}"; i++)); do
	if [ ! -f check${i}.md5 ]; then
		curl --silent ${URL[i]} | md5sum > check${i}.md5
		echo -e "Creating a new fingerprint for ${URL[i]}"
	else
		echo -e "Nothing to do"
	fi
done

# With cache

for ((i = 0 ; i < "${#URLC[@]}"; i++)); do
	if [ ! -f checkcache${i}.md5 ]; then
		curl --silent ${URLC[i]} | md5sum > checkcache${i}.md5
		echo -e "Creating a new fingerprint for ${URLC[i]}"
	else
		echo -e "Nothing to do"
	fi
done

echo 
echo "--- MD5 Check ---"
echo 

# No cache

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

# With cache

for ((i = 0 ; i < "${#URLC[@]}"; i++)); do
	curl --silent "${URLC[i]}" | md5sum > checkcache${i}.md5new
	if ! cmp checkcache${i}.md5 checkcache${i}.md5new > /dev/null; then
		for ((c = 0 ; c < "${#MAIL[@]}"; c++)); do
			echo "Go check ${URLC[i]}" | mail -s "Change detected - MD5 Check " ${MAIL[c]}
		done
		echo -e "Go check ${URLC[i]}" 
		mv checkcache${i}.md5new checkcache${i}.md5
	else
		echo -e "No changes detected in ${URLC[i]}"
		rm checkcache${i}.md5new
	fi
done