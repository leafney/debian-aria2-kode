#!/bin/sh
set -e

# env

echo "***** set php web config *****"

apache2_conf="/etc/apache2/sites-available/000-default.conf"
cat << EOF > $apache2_conf
<VirtualHost *:${KODE_PORT}>
	ServerAdmin webmaster@localhost
	DocumentRoot /web/kode
	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined
	<Directory /web/kode/>
		Options Indexes FollowSymLinks
		AllowOverride None
		Require all granted
	</Directory>
</VirtualHost>

EOF

echo "***** set php web port *****"
port_conf="/etc/apache2/ports.conf"
cat << EOF > $port_conf
Listen ${KODE_PORT}

<IfModule ssl_module>
        Listen 443
</IfModule>

<IfModule mod_gnutls.c>
        Listen 443
</IfModule>
EOF


fi


mkdir -p /app/aria2down
mkdir -p /app/logs

chown -R www-data:www-data /app/aria2down
chmod -Rf 777 /web/
chmod -Rf 777 /app/

echo "***** Done *****"
exec "$@"
