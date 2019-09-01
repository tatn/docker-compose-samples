#!/bin/bash
set -eu

if [ ! -f /var/www/grav/bin/grav ]
then
    cp -a /usr/src/grav-skeleton-blog-site/.  /var/www/grav
fi

exec apache2-foreground
exec "$@"