cp config.json /satis/config.json

echo ""
echo " Your config file"
echo "-----------------------"
cat /satis/config.json
echo "-----------------------"


echo ""
echo " Copying host ssh key from /var/tmp/id to /root/.ssh/id_rsa"
echo "-----------------------"
cp /var/tmp/id /root/.ssh/id_rsa
echo "-----------------------"
echo ""


echo ""
echo " Building Satis for the first time"
echo "-----------------------"
cd /satis && php bin/satis build config.json web/
echo "-----------------------"
echo ""




