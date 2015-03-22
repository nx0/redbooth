#!/bin/bash
RAILS_APP="/var/www/rest_api/"
PACKAGE_DEB_RAILS="redbooth-rails-app_1.1_all.deb"
if [ ! -f $PACKAGE_DEB_RAILS ]; then
	echo "sorry, $PACKAGE_DEB_RAILS not found, exiting..."
	exit 1
fi


if [ "`lsb_release -s -c`" != "wheezy" ]; then
	echo "this installer was only tested on Debian 7 (Wheezy)"
	which apt-get
	if [ $? -gt 0 ]; then
		echo "not a Debian release, exiting..."
		exit 1
	else
		echo "apt-get found, trying to install..."
	fi
fi

echo '
              _ _                 _   _     
 _ __ ___  __| | |__   ___   ___ | |_| |__  
| .__/ _ \/ _. | ._ \ / _ \ / _ \| __| ._ \ 
| | |  __/ (_| | |_) | (_) | (_) | |_| | | |
|_|  \___|\__._|_.__/ \___/ \___/ \__|_| |_|
	     INSTALLER SCRIPT'

echo "[*] installing required Debian packages..."
# apt-get -y install nginx
# apt-get install libmysqlclient-dev

echo "[*] installing RVM ..."
# curl -L https://get.rvm.io | bash -s stable --rails

echo "[*] installing gems..."
# gem install unicorn
# gem install mysql


echo "[*] installing rails app ..."
while [ "$pwd_mysql" == "" ]; do
	echo -n 'please, specify your mysql DB password (default user: root): '
	read pwd_mysql
done

while [ "$http_ip" == "" ]; do
	echo -n 'please, specify the ip to listen for: '
	read http_ip
done

dpkg -i $PACKAGE_DEB_RAILS
if [ $? -eq 0 ]; then
	echo "[*] configuring rails app..."
	## MYSQL PASSW
	sed -i "s/<<PWD_MYSQL>>/$pwd_mysql/g" $RAILS_APP/config/database.yml
	## NGINX LISTEN IP
	sed -i "s/<<HTTP_IP>>/$http_ip/g" $RAILS_APP/config/unicorn.conf

	echo "[*] creating rails databases..."
	cd /var/www/rest_api/
	source /usr/local/rvm/scripts/rvm
	rake db:create
	rake db:migrate
fi

echo "[*] launching unicorn server..."
unicorn_rails -c $RAILS_APP/config/unicorn.rb -D
sleep 5
echo "[*] launching nginx server..."
ln -sf /var/www/rest_api/config/unicorn.conf /etc/nginx/conf.d/unicorn.conf
/etc/init.d/nginx start 
if [ $? -eq 0 ]; then
	echo "CONGRATS!! you can access now to your application: http://${http_ip}:9999"
	exit 0
else
	echo "error installing app, exiting..."
	exit 1
fi
