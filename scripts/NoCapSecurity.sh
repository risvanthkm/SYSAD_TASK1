#!/bin/bash

vault="/opt/Bashrot_vault"
links="$vault/links"
unknown_dir="/unk/"
real_file="$unknown_dir/encoded"
dirs=(/tmp /home /usr /var /etc /opt /srv /dev)

mkdir -p "$links"
mkdir -p "$unknown_dir"
echo "Victory" | base64 > "$real_file"

while true ; do
find "$links" -type l -delete
real_index=$(( $RANDOM % 6767 + 1))

for ((i=1; i<=6767; i++)); do
	link_name="$links/symlink$i"
	if [[  $i -eq $real_index  ]]; then
		ln -s "$real_file" "$link_name"
	
	else 
		random_dir=${dirs[$RANDOM % ${#dirs[@]}]}
		ln -s "$random_dir" "$link_name"
		
	fi
done
sleep 2700
done
