apt-get install -y chafa
apt-get install -y acl

for i in wardens guards bashers; do
	getent group "$i" || groupadd "$i"
done

sudo echo '%wardens ALL=(root) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/permw
sudo echo '%guards ALL=(root) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/permg

echo 'export PATH=$PATH:/scripts' | sudo tee /etc/profile.d/scripts.sh

chmod 644 /etc/profile.d/scripts.sh

echo 'ALL ALL=(root) NOPASSWD: /scripts/LPenalty.sh' | sudo tee /etc/sudoers.d/penalty
chmod 440 /etc/sudoers.d/penalty


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
