FROM ubuntu:16.04

RUN apt-get update \
	&& apt-get install -y --no-install-recommends apache2 php php-curl php-gd php-mbstring php-mcrypt php-xml php-xmlrpc libapache2-mod-php php-mysql php-fpm php-json php-cgi \
	&& sed -i -e '169a\\<Directory /var/www/html/>' /etc/apache2/apache2.conf \
	&& sed -i -e '170a\\    AllowOverride All' /etc/apache2/apache2.conf \
	&& sed -i -e '171a\\</Directory>' /etc/apache2/apache2.conf \
	&& sed -i -e '172a\\' /etc/apache2/apache2.conf \
	&& a2enmod rewrite \
	&& a2enmod php7.0 \
	&& apache2ctl configtest\
	&& rm -rf /var/www/html