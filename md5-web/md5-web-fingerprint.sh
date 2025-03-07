#bin/bash

source "$(dirname "$0")/md5-web-variables.sh"

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
