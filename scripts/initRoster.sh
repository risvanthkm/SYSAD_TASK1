#!/bin/bash

file="roster.yaml"
c=0
users=()

for i in wardens guards bashers; do
	getent group "$i" || groupadd "$i" 


	while read -r name; do
		users+=("$name")
		if [[ "$c" -eq 0 ]] ; then 
			useradd -m -d /home/wardens/$name -s /bin/bash -G wardens "$name"
			chown -R "$name:$name" /home/wardens/$name	
			mkdir -p /home/wardens/$name/.ssh
			yq -r '.roster.wardens[] | select(.username == "'"$name"'") | .public_key' "$file"> /home/wardens/$name/.ssh/authorized_keys
			chown -R "$name:$name" /home/wardens/$name/.ssh
			chmod 700 /home/wardens/$name/.ssh
			chmod 600 /home/wardens/$name/.ssh/authorized_keys
			img_url=$(yq -r '.roster.wardens[] | select(.username=="'"$name"'") | .image_url' "$file")
			curl -L "$img_url" -o /tmp/$name.jpg
			chafa /tmp/$name.jpg >> /home/wardens/$name/.avatar.txt
			chown "$name:$name" /home/wardens/$name/.avatar.txt
			echo "cat ~/.avatar.txt" >> "/home/wardens/$name/.bashrc"
			cat >> /home/wardens/$name/.bashrc <<-'EOF'
			alias raid='ls'
			alias allout='clear'
			alias mog='tail'  
EOF
					
		elif [[ "$c" -eq 1 ]] ; then 
			useradd -m -d /home/guards/$name -s /bin/bash -G guards "$name"
			chown -R "$name:$name" /home/guards/$name
			mkdir -p /home/guards/$name/.ssh
			yq -r '.roster.guards[] | select(.username=="'"$name"'") | .public_key' "$file" > /home/guards/$name/.ssh/authorized_keys
			chown -R "$name:$name" /home/guards/$name/.ssh
			chmod 700 /home/guards/$name/.ssh
			chmod 600 /home/guards/$name/.ssh/authorized_keys
			img_url=$(yq -r '.roster.guards[] | select(.username=="'"$name"'") | .image_url' "$file")
			curl -L "$img_url" -o /tmp/$name.jpg
			chafa /tmp/$name.jpg >> /home/guards/$name/.avatar.txt
			chown "$name:$name" /home/guards/$name/.avatar.txt
			echo "cat ~/.avatar.txt" >> "/home/guards/$name/.bashrc" 
			cat >> /home/guards/$name/.bashrc <<-'EOF'
			alias scan='ls'
			alias nuke='clear'
			alias last='tail'
EOF
			
		elif [[ "$c" -eq 2 ]] ; then 
			useradd -m -d /home/bashers/$name -s /bin/bash -G bashers "$name"
			chown -R "$name:$name" /home/bashers/$name
			mkdir -p /home/bashers/$name/Drop_Zone
			setfacl -m g:guards:rwx /home/bashers/$name
			setfacl -d -m g:guards:rwx /home/bashers/$name
			passwd -l "$name"
			mkdir -p /home/bashers/$name/.ssh
			yq -r '.roster.bashers[] | select(.username == "'"$name"'") | .public_key' "$file" > /home/bashers/$name/.ssh/authorized_keys
			chown -R "$name:$name" /home/bashers/$name/.ssh
			chmod 700 /home/bashers/$name/.ssh
			chmod 600 /home/bashers/$name/.ssh/authorized_keys
			img_url=$(yq -r '.roster.bashers[] | select(.username == "'"$name"'") | .image_url' "$file")
			curl -L "$img_url" -o /tmp/$name.jpg
			chafa /tmp/$name.jpg >> /home/bashers/$name/.avatar.txt
			chown "$name:$name" /home/bashers/$name/.avatar.txt
			echo "cat ~/.avatar.txt" >> "/home/bashers/$name/.bashrc" 
			mkdir -p /home/bashers/$name/bin
			ln -s /bin/ls    /home/bashers/$name/bin/ls
			ln -s /bin/pwd   /home/bashers/$name/bin/pwd
			ln -s /usr/bin/clear /home/bashers/$name/bin/clear
			ln -s /usr/bin/tail  /home/bashers/$name/bin/tail
			chown -R $name:$name /home/bashers/$name/bin
			cat >> "/home/bashers/$name/.bashrc" <<-'EOF'
			alias peek='ls'
			alias wipe='clear'
			alias finale='tail'
			alias sus='pwd'
EOF
			
			cat >> "/home/bashers/$name/.bashrc" <<-'EOF'
			if [[ "$SHELL" == "/bin/rbash" ]]; then
				export PATH="/home/bashers/$USER/bin"
			fi
			EOF
			
			echo "trap 'sudo /scripts/LPenalty.sh \"\$BASH_COMMAND\" \"\$USER\"' DEBUG" >> "/home/bashers/$name/.bashrc"
		fi
			
		echo $name
	done < <( yq -r ".roster.$i[].username" "$file" )
	((c++))
done 

e_users=(
  $(getent group bashers | cut -d: -f4 | tr ',' ' ')
  $(getent group guards  | cut -d: -f4 | tr ',' ' ')
  $(getent group wardens | cut -d: -f4 | tr ',' ' ')
)


for user in "${e_users[@]}"; do
    found=0

    for u in "${users[@]}"; do
        [[ "$u" == "$user" ]] && found=1
    done

    if (( !found )); then
        userdel "$user"
    fi
done
