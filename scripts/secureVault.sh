#!/bin/bash

vault="/opt/Bashrot_vault"

mkdir -p "$vault"

setfacl -m g:wardens:rwx "$vault"
setfacl -m g:guards:rwx "$vault"
setfacl -m g:bashers:--- "$vault"

mkdir -p "$vault/.cache_data"

setfacl -m g:bashers:--x "$vault/.cache_data"
