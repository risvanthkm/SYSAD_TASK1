#!/bin/bash

path="/home/bashers"
logFilename="aura_tax_log.log"
scriptLocation="/scripts/collectTax.sh"

find  $path -size +5M | cut -d/ -f4 | while read -r user ; do
	find "$path/$user/" -type f -not -name ".bashrc" -not -name ".avatar.txt" -printf '%T@ %p %s\n' | sort -n | head -3 | while read -r files ; do

		timestamp=$(echo "$files" | cut -d' ' -f1) 
		filename=$(echo "$files" | cut -d' ' -f2) 
		size=$(echo "$files" | cut -d' ' -f3)
		
		username=$(basename "$user")
		echo "[$timestamp] | $username | $size | $filename" >> "$logFilename"
		rm "$filename"  
	done
done

if [[ -f "$logFilename" ]]; then
	chmod 770 "$logFilename"
	setfacl -m g:wardens:rwx "$logFilename"
	setfacl -m g:guards:rwx "$logFilename"
	setfacl -m g:bashers:--- "$logFilename"

	echo "Leaderboard of Aura Tax"
	awk -F'\\| ' '{sum[$2]+=$3} END {for (u in sum) printf "%s %.2f KB\n", u, sum[u]/1024}' "$logFilename" | sort -k2 -nr

else
	echo "**NO LOGS**"
fi

echo "*/5 * * * 5-6 $scriptLocation" | crontab -
 
	
		
