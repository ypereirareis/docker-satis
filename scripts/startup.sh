DEFAULT_CRONTAB_FREQUENCY="* * * * *"
DEFAULT_CRONTAB_FREQUENCY_ESCAPED=$(printf '%s\n' "${DEFAULT_CRONTAB_FREQUENCY}" | sed 's/[[\.*^$/]/\\&/g')

[ -z "$CRONTAB_FREQUENCY" ] && CRONTAB_FREQUENCY="$DEFAULT_CRONTAB_FREQUENCY"
CRONTAB_FREQUENCY_ESCAPED=$(printf '%s\n' "${CRONTAB_FREQUENCY}" | sed 's/[[\.*^$/]/\\&/g')

echo ""
cat config.json
echo ""
echo ""

echo " >> Creating the correct known_hosts file"
TARGET_DOMAIN_LIST="$PRIVATE_REPO_DOMAIN $PRIVATE_REPO_DOMAIN_LIST"
for _DOMAIN in $TARGET_DOMAIN_LIST ; do
    ssh-keyscan -t rsa $_DOMAIN >> /root/.ssh/known_hosts
done

echo " >> Copying host ssh key from /var/tmp/id to /root/.ssh/id_rsa"
cp /var/tmp/id /root/.ssh/id_rsa


echo " >> Building Satis for the first time"
scripts/build.sh

if [[ $CRONTAB_FREQUENCY == -1 ]]; then

  echo " > No Cron"

else

  echo " > Crontab frequency set to: ${CRONTAB_FREQUENCY}"
  sed -i "s/${DEFAULT_CRONTAB_FREQUENCY_ESCAPED}/${CRONTAB_FREQUENCY_ESCAPED}/g" /etc/cron.d/satis-cron

  echo " >> Starting cron"
  cron &

fi

# Copy custom config if exists
[[ -f /app/config.php ]] && cp /app/config.php  /satisfy/app/config.php

if [[ -f /app/scripts/crontab ]]; then
  cp /app/scripts/crontab /etc/cron.d/satis-cron
  chmod 0644 /etc/cron.d/satis-cron
  touch /var/log/satis-cron.log
fi


chmod -R 777 /app/config.json
service php5-fpm start && nginx &

echo " >> Starting node web server"
cd /app && node server.js

