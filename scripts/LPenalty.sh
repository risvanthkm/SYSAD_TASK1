#!/bin/bash

[[ "$1" == *LPenalty* ]] && exit 0
[[ "$1" == *sudo* ]] && exit 0

warden=$(getent group wardens | cut -d: -f4 | cut -d, -f1)
txt_location="/home/wardens/$warden/penalties"
mkdir -p "$txt_location"

# /etc/sudoers.d/penalty
#ALL ALL=(root) NOPASSWD: /scripts/LPenalty.sh

declare -A restricted_cmds
restricted_cmds["rm -rf /"]=1000000
restricted_cmds["rm -rf"]=800000
restricted_cmds["chmod 777 /"]=900000
restricted_cmds["chmod [0-7]* /"]=800000
restricted_cmds["cd /home/wardens"]=300000
restricted_cmds["ls /home/wardens"]=100000
restricted_cmds["cat /home/wardens"]=100000

user_name="${2:-$(whoami)}"
cmd="$1"

threshold=2912008
penalty=0

if ! groups "$user_name" | grep -qw "bashers"; then
    exit 0
fi

txt_file="${txt_location}/${user_name}.txt"

for r_cmd in "${!restricted_cmds[@]}" ; do
	if [[ "$cmd" =~ $r_cmd ]]; then
		penalty="${restricted_cmds[$r_cmd]}"
		
		echo "$cmd:$penalty" >> "$txt_file"
	fi
done

total_penalty=0

if [[ -f "$txt_file" ]]; then
	total_penalty=$(awk -F: '{sum+=$2} END {print sum}' "$txt_file")
fi 

if [[ $total_penalty -gt $threshold ]]; then
	
	# we do this to check whether he is already punished 
	current_shell=$(getent passwd "$user_name" | cut -d: -f7)

	if [[ "$current_shell" != "/bin/rbash" ]]; then
    	usermod -s /bin/rbash "$user_name"
    	pkill -u "$user_name" -o
		(
		    sleep 1800
		    usermod -s /bin/bash "$user_name"
		    rm -f "$txt_file"
		) & disown
	fi
fi








