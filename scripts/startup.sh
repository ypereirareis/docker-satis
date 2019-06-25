#!/bin/bash
set -e

# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow

DEFAULT_CRONTAB_FREQUENCY="* * * * *"
DEFAULT_CRONTAB_FREQUENCY_ESCAPED=$(printf '%s\n' "${DEFAULT_CRONTAB_FREQUENCY}" | sed 's/[[\.*^$/]/\\&/g')

[[ -z "${CRONTAB_FREQUENCY}" ]] && CRONTAB_FREQUENCY="$DEFAULT_CRONTAB_FREQUENCY"
CRONTAB_FREQUENCY_ESCAPED=$(printf '%s\n' "${CRONTAB_FREQUENCY}" | sed 's/[[\.*^$/]/\\&/g')


if [[ ! -z "$PRIVATE_REPO_DOMAIN" ]]; then
  echo ""
  echo -e "$Yellow"
  echo "======================================================================"
  echo "PRIVATE_REPO_DOMAIN env var is now PRIVATE_REPO_DOMAIN_LIST !!! "
  echo "----------------------------------------------------------------------"
  echo " Or use tag 1.0.0 to stay compatible with PRIVATE_REPO_DOMAIN env var"
  echo "ypereirareis/docker-satis:1.0.0"
  echo "======================================================================"
  echo -e "$Color_Off"

  exit 1
fi

test -e /satisfy/config/parameters.satisfy.yml && rm -rf /satisfy/app/config/parameters.yml && ln -s /satisfy/config/parameters.satisfy.yml /satisfy/app/config/parameters.yml
test -e /satisfy/config/satis.json && rm -rf /satisfy/satis.json && ln -s /satisfy/config/satis.json /satisfy/satis.json


touch ${USER_HOME}/.ssh/known_hosts

if [[ -f /var/tmp/sshconf ]]; then
    echo " >> Copying host ssh config from /var/tmp/sshconf to ${USER_HOME}/.ssh/config"
    cp /var/tmp/sshconf "${USER_HOME}/.ssh/config"
fi

echo " >> Creating the correct known_hosts file"
for _DOMAIN in ${PRIVATE_REPO_DOMAIN_LIST} ; do
    IFS=':' read -a arr <<< "${_DOMAIN}"
    if [[ "${#arr[@]}" == "2" ]]; then
        port="${arr[1]}"
        ssh-keyscan -t rsa,dsa -p "${port}" ${arr[0]} >> ${USER_HOME}/.ssh/known_hosts
    else
        ssh-keyscan -t rsa,dsa ${_DOMAIN} >> ${USER_HOME}/.ssh/known_hosts
    fi
done

echo " >> Copying host ssh key from /var/tmp/id to ${USER_HOME}/.ssh/id_rsa"
cp /var/tmp/id "${USER_HOME}/.ssh/id_rsa" && chmod 600 "${USER_HOME}/.ssh/id_rsa"

chown -R www-data:www-data /var/www
chown -R www-data:www-data /satisfy/satis.json && chmod 777 /satisfy/satis.json

echo " >> Building Satis for the first time"
scripts/build.sh

if [[ ${CRONTAB_FREQUENCY} == -1 ]]; then
  echo " > No Cron"
else
  echo " > Crontab frequency set to: ${CRONTAB_FREQUENCY}"
  sed -i "s/${DEFAULT_CRONTAB_FREQUENCY_ESCAPED}/${CRONTAB_FREQUENCY_ESCAPED}/g" /etc/cron.d/satis-cron
fi

exit 0
