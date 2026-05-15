pkill generateLore.sh

folder="/home/bashers"
bashrot="/opt/Bashrot_vault"

find "$folder" -mindepth 1 -type f -delete

find "$bashrot" -type f -delete

setfacl -R -b "$bashrot"

