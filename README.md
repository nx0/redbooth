#INTRODUCTION

The application has three parts:
* installer.sh - install all the system requirements 
* deb package - It is the main package of the rails application with all the required files inside (the package was created using: *fpm*)
* client.sh - interact with the api. NOTE: You have to define the HTTP_HOST variable in your env (example: export HTTP_HOST="localhost") and execute the client propertly (example: ./client.sh queryall)


#INSTALL INSTRUCTIONS

## Start the instance
Start unicorn dameon: 
* # unicorn_rails -c /var/www/rest_api/config/unicorn.rb -D
Start nginx server:
* # /etc/init.d/nginx start

## Stop the instance
Stop nginx daemon:
* # /etc/init.d/nginx stop
Stop unicorn daemon:
* # ps faux | grep unicorn | grep -v grep | awk '{ print $2 }' | head -n 1 | xargs kill


## (Re) provisioning
Just launch the: installer.sh 

