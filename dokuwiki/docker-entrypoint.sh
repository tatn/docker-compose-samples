#!/bin/bash
set -eu

if [ ! -f /var/www/html/doku.php ]
then
    rsync -a -q -x /usr/src/dokuwiki/ /var/www/html
    chown -R www-data:www-data /var/www/html
fi

exec apache2-foreground
exec "$@"