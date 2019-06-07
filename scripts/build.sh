#!/usr/bin/env bash
sudo -u www-data bash -c 'id; cd /satisfy && /satisfy/bin/satis build --skip-errors --no-ansi --verbose'
