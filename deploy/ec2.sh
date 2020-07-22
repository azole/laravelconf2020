#!/bin/bash

## Meta Data
  # -*- encode: UTF-8 -*-

## Exit if any errors occur
  set -Eex -u -o pipefail

## function

  function install_pecl() {

    echo "Start to install ${1}${2}"

    if ! pecl list | grep ${1} >/dev/null 2>&1;
    then
      echo '' | sudo pecl install ${1}${2} ||
      {
        # echo_err "Could not pecl install ${1}";
        exit 1;
      }
    else
      echo "${1}${2} is already installed"
    fi

    sudo bash -c "echo extension=${1}.so > /etc/php.d/${3}"
  }

  function install_rpm() {

    cd ~

    if sudo rpm -qa | grep ${1}  2>&1 > /dev/null; then
      echo "${1} is already installed"
    else
      echo "Start to install ${1}"
      wget -q ${2}
      sudo rpm -Uvh ${3}
    fi
  }

## send log to /var/log/message
  exec 1> >(logger -s -t $(basename $0)) 2>&1

sudo bash -c 'echo LANG="en_US.UTF-8" >> /etc/environment'
sudo bash -c 'echo LC_MESSAGES="C" >> /etc/environment'
sudo bash -c 'echo LC_ALL="en_US.UTF-8" >> /etc/environment'


## update system
  sudo yum update -y

## install development tool
  sudo yum groupinstall -y "Development tools"
  sudo yum install -y git libpng libjpeg openssl libmcrypt gd-last icu libX11 libXext libXrender xorg-x11-fonts-Type1 xorg-x11-fonts-75dpi libzip

## install apache
  sudo yum install -y httpd
  sudo yum install -y mod_ssl

## install php71
  sudo amazon-linux-extras install -y php7.2
  ### php7.1 recommends php-cli                    # yum install php-cli
  ### php7.1 recommends php-pdo                    # yum install php-pdo
  ### php7.1 recommends php-fpm                    # yum install php-fpm
  ### php7.1 recommends php-json                   # yum install php-json
  ### php7.1 recommends php-mysqlnd                # yum install php-mysqlnd
  sudo yum install -y php-devel php-common php-mbstring php-xml php-soap php-pecl-imagick php-gd php-bcmath
  ### php-mcrypt php-pecl-redis php-pecl-mongodb
  sudo yum install -y  php-pear
  sudo yum install -y libzip-devel
  #install_pecl zip "" "30-zip.ini"
  install_pecl redis "" "30-redis.ini"
  sudo yum install -y libmcrypt-devel
  install_pecl mcrypt "-1.0.0" "30-mcrypt.so.ini"
  #install_pecl mongodb "" "40-mongodb.so.ini"

## install composer
  curl -sS https://getcomposer.org/installer | php
  sudo mv composer.phar /usr/local/bin/composer

## install npm
  curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -
  sudo yum install -y nodejs

## create apache config and start httpd / php-fpm
  #sudo cp config/apache/httpd.conf /etc/httpd/conf/httpd.conf
  #sudo cp config/php/php.ini /etc/php.ini

  sudo rm -f /etc/httpd/conf.d/ssl.conf

  sudo httpd -k start
  sudo systemctl start php-fpm

## auto start after reboot
### php-fpm
  sudo systemctl enable php-fpm
### httpd
  sudo systemctl enable httpd.service

### install project
  cd /var/www
  sudo rm -rf html
  sudo mkdir -p /var/www/projects
  sudo chown ec2-user:root /var/www/projects
  cd /var/www/projects
  git clone https://github.com/azole/laravelconf2020.git
  cd laravelconf2020
  composer install
  cp .env.example .env
  php artisan k:g
  php artisan storage:link
  npm install
  npm run prod
  sudo ln -sfn /var/www/projects/laravelconf2020/public /var/www/html
  sudo chown -R ec2-user:apache /var/www/projects/laravelconf2020/storage
  cp deploy/config/apache/httpd.conf /etc/httpd/conf/httpd.conf
  sudo httpd -k restart

### install cron
  if [ $(crontab -l | grep "artisan" | wc -c) -eq 0 ]; then
    set +e
    echo "set crontab"
    ( crontab -l ; echo "* * * * * php /var/www/projects/laravelconf2020/artisan schedule:run >> /dev/null 2>&1" ) | crontab -
    set -ex -u -o pipefail
  fi
