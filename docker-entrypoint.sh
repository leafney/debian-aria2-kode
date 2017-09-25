#!/bin/sh
set -e

# env 
KODE_PORT=${KODE_PORT:-"80"}
WEBUI_PORT=${WEBUI_PORT:-"6801"}
RPC_LISTEN_PORT=${RPC_LISTEN_PORT:-"6800"}


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

<VirtualHost *:${WEBUI_PORT}>
	ServerAdmin webmaster2@localhost
	DocumentRoot /web/ariaNg
	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined
	<Directory /web/ariaNg/>
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
Listen ${WEBUI_PORT}

<IfModule ssl_module>
        Listen 443
</IfModule>

<IfModule mod_gnutls.c>
        Listen 443
</IfModule>
EOF

aria2_conf="/app/conf/aria2.conf"
aria2_session="/app/conf/aria2.session"

if [ -f "$aria2_conf" ]; then
	echo "***** Loading aria2 config *****"
else
	echo "***** Creating default aria2 config *****"
	mkdir -p /app/conf

	cat << EOF >> $aria2_conf
dir=/app/aria2down
continue=true
input-file=/app/conf/aria2.session
save-session=/app/conf/aria2.session
enable-rpc=true
rpc-allow-origin-all=true
rpc-listen-all=true
rpc-listen-port=$RPC_LISTEN_PORT
rpc-secret=123456
EOF

fi

if [ -f "$aria2_session" ]; then
	echo "***** Loading aria2 session file *****"
else
	echo "***** Creating default aria2 session file *****"
	touch $aria2_session
fi

mkdir -p /app/aria2down
mkdir -p /app/logs

chown -R aria2:aria2 /app/aria2down
chmod -Rf 777 /web/
chmod -Rf 777 /app/

echo "***** Done *****"
exec "$@"