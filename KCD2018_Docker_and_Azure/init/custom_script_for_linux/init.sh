#!/bin/bash

# Wordpress 초기화
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ wheezy main" | tee /etc/apt/sources.list.d/azure-cli.list
apt-key adv --keyserver packages.microsoft.com --recv-keys 417A0893
apt-get install apt-transport-https
apt-get update
apt-get install -y --no-install-recommends apache2 php php-curl php-gd php-mbstring php-mcrypt php-xml php-xmlrpc libapache2-mod-php php-mysql php-fpm php-json php-cgi docker.io azure-cli
sed -i -e '169a\\<Directory /var/www/html/>' /etc/apache2/apache2.conf
sed -i -e '170a\\    AllowOverride All' /etc/apache2/apache2.conf
sed -i -e '171a\\</Directory>' /etc/apache2/apache2.conf
sed -i -e '172a\\' /etc/apache2/apache2.conf
a2enmod rewrite
a2enmod php7.0
apache2ctl configtest

# Wordpress 다운로드 및 설정
cd /tmp
curl -O https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
touch /tmp/wordpress/.htaccess
chmod 660 /tmp/wordpress/.htaccess
cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php
mkdir /tmp/wordpress/wp-content/upgrade
sed -i -e 's/database_name_here/wpdatabase/' /tmp/wordpress/wp-config.php
sed -i -e 's/password_here/Pa55w0rd/' /tmp/wordpress/wp-config.php

sed -i -e '83a\\' /tmp/wordpress/wp-config.php
sed -i -e '84a\\define("FS_METHOD", "direct");' /tmp/wordpress/wp-config.php
sed -i -e '85a\\define("WP_HOME", "http://". filter_input(INPUT_SERVER, "HTTP_HOST", FILTER_SANITIZE_STRING));' /tmp/wordpress/wp-config.php
sed -i -e '86a\\define("WP_SITEURL", "http://". filter_input(INPUT_SERVER, "HTTP_HOST", FILTER_SANITIZE_STRING));' /tmp/wordpress/wp-config.php
sed -i -e '87a\\define("WP_CONTENT_URL", "/wp-content");' /tmp/wordpress/wp-config.php
sed -i -e '88a\\define("DOMAIN_CURRENT_SITE", filter_input(INPUT_SERVER, "HTTP_HOST", FILTER_SANITIZE_STRING));' /tmp/wordpress/wp-config.php
sed -i -e '89a\\' /tmp/wordpress/wp-config.php
sed -i -e '90a\\' /tmp/wordpress/wp-config.php

# Wordpress 복사
rm -rf /var/www/html
sudo cp -a /tmp/wordpress/. /var/www/html

# Wordpress 권한 수정
chown -R www-data:www-data /var/www/html
chmod -R g+w /var/www/html

# Docker init
cd ~
curl -O https://raw.githubusercontent.com/krazure/hands-on-lab/master/KCD2018_Docker_and_Azure/init/Dockerfile/Dockerfile
docker build -t wpinit .

cd /var/www
curl -O https://raw.githubusercontent.com/krazure/hands-on-lab/master/KCD2018_Docker_and_Azure/script/Dockerfile/Dockerfile