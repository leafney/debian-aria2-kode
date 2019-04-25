FROM debian:jessie
MAINTAINER leafney "babycoolzx@126.com"

ENV KODE_PORT=6880 \
	GOSU_VERSION=1.11 \
	KODE_VERSION=4.39 \

RUN apt-get update && apt-get install -y \
		unzip \
		supervisor \
		apache2 \
		php5 \
		libapache2-mod-php5 \
		php5-gd \
		php5-curl \
		openssh-server \
	&& echo "files = /etc/aria2/start.ini" >> /etc/supervisor/supervisord.conf \
	&& mkdir -p /app/conf \
	&& mkdir -p /app/logs \
	&& mkdir -p /web/kode \
	&& rm -rf /var/lib/apt/lists/* \
	&& aria2c -o /usr/local/bin/gosu https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64 \
	&& chmod +x /usr/local/bin/gosu \
	&& aria2c -o /web/kode.zip https://github.com/kalcaddle/KodExplorer/archive/${KODE_VERSION}.zip \
	&& unzip /web/kode.zip -d /web \
	&& mv /web/KodExplorer-${KODE_VERSION}/* /web/kode/ \
	&& rm /web/kode.zip \
	&& rm -rf /web/KodExplorer-${KODE_VERSION}

COPY ./start.ini /etc/aria2/

COPY ./docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh \
	&& chmod +x usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

VOLUME ["/app"]

EXPOSE $KODE_PORT

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
