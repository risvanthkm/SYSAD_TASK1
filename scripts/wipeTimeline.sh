#!/bin/bash

pkill generateLore.sh

folder="/home/bashers"
bashrot="/opt/Bashrot_vault"

find "$folder" -not -name ".bashrc" -not -name ".avatar.txt" -mindepth 1 -type f -delete

find "$bashrot" -type f -delete

setfacl -R -b "$bashrot"

bash /scripts/secureVault.sh
