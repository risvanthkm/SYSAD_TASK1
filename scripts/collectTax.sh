#!/bin/bash

path="/home/bashers"
logFilename="aura_tax_log.log"
scriptLocation="/scripts/collectTax.sh"

du -sm "$path"/*/ | awk '$1 > 5 {print $2}' | while read -r userdir; do
	find "$userdir/" -type f -not -name ".bashrc" -not -name ".avatar.txt" -printf '%T@ %p %s\n' | sort -n | head -3 | while read -r timestamp filename size; do
		size_kb=$(echo "scale=2; $size/1024" | bc)
		username=$(basename "$userdir")
		echo "[$timestamp] | $username | $size_kb | $filename" >> "$logFilename"
		rm -- "$filename"  
	done
done

if [[ -f "$logFilename" ]]; then
	chmod 770 "$logFilename"
	setfacl -m g:wardens:rwx "$logFilename"
	setfacl -m g:guards:rwx "$logFilename"
	setfacl -m g:bashers:--- "$logFilename"

	echo "Leaderboard of Aura Tax"
	awk -F'\\| ' '{sum[$2]+=$3} END {for (u in sum) printf "%s %.2f KB\n", u, sum[u]}' "$logFilename" | sort -k2 -nr

else
	echo "**NO LOGS**"
fi

crontab -l | grep -q "$scriptLocation" || (crontab -l 2>/dev/null; echo "*/5 * * * 5-6 $scriptLocation") | crontab -
 
	
		
