#!/bin/sh

EXPECTED_CHECKSUM=$(curl -s https://getcomposer.org/download/latest-2.x/composer.phar.sha256sum)
wget https://getcomposer.org/download/latest-2.x/composer.phar
ACTUAL_CHECKSUM="$(sha256sum composer.phar)"

if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
then
    >&2 echo 'ERROR: Invalid composer checksum'
    rm composer.phar
    exit 1
fi

mv composer.phar /usr/local/bin/composer && chmod +x /usr/local/bin/composer
composer --version
RESULT=$?
exit $RESULT
