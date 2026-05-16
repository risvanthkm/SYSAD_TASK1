#!/bin/bash

slangfile="/scripts/slang.txt"
logfile="heist.log"

while true; do 
	echo Checking
	for user_dir in  /home/bashers/*/ ; do
		echo $user_dir
		file=$(find "$user_dir/Drop_Zone/" -type f -mmin -1 | head -n 1) #
		echo $file
		[[ -z "$file" ]] && continue
        echo "Checking file: $file"
        decoded=$(base64 -d "$file" ) #
		username=$(basename "$user_dir")
		while read -r word; do
			if [[ "$decoded" == "$word" ]] ; then
				msg="Basher $username stole a bashrot !!!"
                wall "$msg"
                echo "$(date +%s) | $username | $word" >> "$logfile"
            fi

        done < "$slangfile"
	done
	sleep 59
done			
			


