apt-get install -y chafa
apt-get install -y acl

for i in wardens guards bashers; do
	getent group "$i" || groupadd "$i"
done

sudo echo '%wardens ALL=(root) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/permw

echo 'ALL ALL=(root) NOPASSWD: /scripts/LPenalty.sh' | sudo tee /etc/sudoers.d/penalty
chmod 440 /etc/sudoers.d/penalty

echo 'ALL ALL=(root) NOPASSWD: /scripts/collectTax.sh' | sudo tee /etc/sudoers.d/guard
chmod 440 /etc/sudoers.d/guard


chown root:root /scripts/*
chmod 750 /scripts/*
setfacl -m g:wardens:rx /scripts/initRoster.sh
setfacl -m g:wardens:rx /scripts/secureVault.sh
setfacl -m g:wardens:rx /scripts/generateLore.sh
setfacl -m g:wardens:rx /scripts/collectTax.sh
setfacl -m g:guards:rx /scripts/collectTax.sh
setfacl -m g:wardens:rx /scripts/verifyHeist.sh
setfacl -m g:wardens:rx /scripts/trendSetters.sh
setfacl -m g:wardens:rx /scripts/wipeTimeline.sh
setfacl -m g:wardens:rx /scripts/NoCapSecurity.sh
