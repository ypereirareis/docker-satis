cp config.json /satis/config.json

echo ""
cat /satis/config.json
echo ""
echo ""

echo " >> Creating the correct known_hosts file"
ssh-keyscan -t rsa $PRIVATE_REPO_DOMAIN >> /root/.ssh/known_hosts


echo " >> Copying host ssh key from /var/tmp/id to /root/.ssh/id_rsa"
cp /var/tmp/id /root/.ssh/id_rsa


echo " >> Building Satis for the first time"
/satis/build.sh


echo " >> Starting cron"
cron &


echo " >> Starting node web server"
cd /app && node server.js

