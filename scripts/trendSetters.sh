#!/bin/bash

if ! id -Gn | grep -qw "wardens"; then
	echo "Access denied: wardens only."
    exit 1
fi

leaderboard="leaderboard.log"
heist="heist.log"
streak_factor=200
clutch_bonus=100
decay_factor=0.0001

declare -A scores
declare -A old_pos
declare -A prev_time
declare -A activity
declare -A last_heist_time

if [[ -f "$leaderboard" ]]; then
    pos=1
    while IFS=':' read -r user score movement; do
        old_pos["$user"]="$pos"
        ((pos++))
    done < "$leaderboard"
fi

crr_time=$(date +%s)
last_day=$(( crr_time - 86400 ))


while read -r time name; do
    name=$(echo "$name" | xargs)

    if [[ -z "${last_heist_time[$name]}" || $time -gt ${last_heist_time[$name]} ]]; then
        last_heist_time["$name"]="$time"
    fi

    if [[ -n "${prev_time[$name]}" ]]; then
        if (( time - ${prev_time[$name]:-0} <= 300 )); then
            activity["$name"]=$(( ${activity[$name]:-0} + 1 ))
        fi
    fi
    prev_time["$name"]="$time"

done < <(awk -F' \\| ' -v last="$last_day" '$1+0 > last { print $1, $2 }' "$heist" | sort -k1 -n)


max=0
user_with_max=""
for user in "${!activity[@]}"; do
    if [[ "${activity[$user]}" -gt $max ]]; then
        max="${activity[$user]}"
        user_with_max="$user"
    fi
done
[[ -n "$user_with_max" ]] && scores["$user_with_max"]=$(( max * streak_factor ))

c_user=$(awk -F' \\| ' '{ print $1, $2 }' "$heist" | sort -k1 -rn | head -1 | awk '{print $2}' | xargs)
[[ -n "$c_user" ]] && scores["$c_user"]=$(( ${scores[$c_user]:-0} + clutch_bonus ))

for user in "${!last_heist_time[@]}"; do
    [[ -z "${scores[$user]}" ]] && scores["$user"]=1
done

for basher in "${!scores[@]}"; do
    score=${scores["$basher"]}
    [[ -z "$score" || "$score" == "0" ]] && score=1

    elapsed=$(( crr_time - ${last_heist_time[$basher]:-$crr_time} ))
    [[ $elapsed -lt 1 ]] && elapsed=1

    log_val=$(echo "l($elapsed)" | bc -l)
    scores["$basher"]=$(echo "scale=4; $score - ($decay_factor * $log_val)" | bc -l)
done

active_count=${#scores[@]}
[[ $active_count -lt 1 ]] && active_count=1

for basher in "${!scores[@]}"; do
    scores["$basher"]=$(echo "scale=4; ${scores[$basher]} / $active_count" | bc -l)
done

sorted_users=$(
    for user in "${!scores[@]}"; do
        echo "${scores[$user]} ${last_heist_time[$user]:-0} $user"
    done | sort -k1 -rn -k2 -rn | awk '{print $3}'
)

echo "Leaderboard of bashers"
pos=1
> "$leaderboard"

while IFS= read -r user; do
    score=${scores[$user]}

    if [[ ${#old_pos[@]} -gt 0 ]]; then
        if [[ -n "${old_pos[$user]}" ]]; then
            delta=$(( old_pos[$user] - pos ))
            if   [[ $delta -gt 0 ]]; then movement="(+$delta UP)"
            elif [[ $delta -lt 0 ]]; then movement="($delta DOWN)"
            else movement="(no change)"
            fi
        else
            movement="(new entry)"
        fi
    else
        movement=""
    fi
	
	if [[ $pos -lt 4 ]]; then
    	echo "$pos. | $user | Score: $score $movement"
    fi
    
    ((pos++))
    echo "$user:$score:$movement" >> "$leaderboard"
    
done <<< "$sorted_users"

setfacl -m g:wardens:rwx "$leaderboard"
setfacl -m g:guards:rwx  "$leaderboard"
setfacl -m o::---        "$leaderboard"
