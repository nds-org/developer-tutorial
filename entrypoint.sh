#!/bin/bash
set -e

if [ ! -e '/var/www/html/version.php' ]; then
	tar cf - --one-file-system -C /usr/src/owncloud . | tar xf -
	cp /tmp/setup.php /var/www/html/lib/private/
	chown -R www-data /var/www/html
fi

exec "$@"
