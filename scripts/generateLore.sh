#!/bin/bash

filename="/scripts/slang.txt"
vault="/opt/Bashrot_vault"
bad_words=("crap" "heck" "damn" "fool")

words=$(cat "$filename")

for word in "${bad_words[@]}"; do 
	stars=""
	for ((i=0; i<"${#word}"; i++)); do
		stars+="*"
	done
	words=$(sed "s/$word/$stars/gi" <<< "$words")
done

mapfile -t word_arr <<< "$words"

while true; do
	random_word="${word_arr[$RANDOM % ${#word_arr[@]}]}"

	encoded=$(echo -n "$random_word" | base64)
	
	file="$vault/encoded_$(date +%s)"
    echo "$encoded" > "$file"
    
    sleep 30
done

