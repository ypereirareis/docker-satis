cp config.json /satis/config.json

echo ""
echo " Your config file"
echo "-----------------------"
cat /satis/config.json
echo "-----------------------"


echo ""
echo Creating the correct known_hosts file
echo "-----------------------"

ssh-keyscan -t rsa $PRIVATE_REPO_DOMAIN >> /root/.ssh/known_hosts

echo ""
echo " Copying host ssh key from /var/tmp/id to /root/.ssh/id_rsa"
echo "-----------------------"
cp /var/tmp/id /root/.ssh/id_rsa
echo ""


echo ""
echo " Building Satis for the first time"
echo "-----------------------"
cd /satis && php bin/satis build config.json web/
echo "-----------------------"
echo ""

cron &
cd /app && node server.js

