#!/bin/bash

# Wordpress 초기화
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ wheezy main" | tee /etc/apt/sources.list.d/azure-cli.list
apt-key adv --keyserver packages.microsoft.com --recv-keys 417A0893
apt-get install apt-transport-https
apt-get update && apt-get upgrade -y
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