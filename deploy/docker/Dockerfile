FROM amazonlinux

# system update and configuration
RUN yum update -y \
  && bash -c 'echo LANG="en_US.UTF-8" >> /etc/environment' \
  && bash -c 'echo LC_MESSAGES="C" >> /etc/environment' \
  && bash -c 'echo LC_ALL="en_US.UTF-8" >> /etc/environment'

# install development tools
RUN yum groupinstall -y "Development tools" \
  && yum install -y libpng libjpeg openssl libmcrypt gd-last icu libX11 libXext libXrender xorg-x11-fonts-Type1 xorg-x11-fonts-75dpi libzip \
  && yum install -y wget \
  && yum install -y aws-cli \
  && yum install -y git

# install web server, php and php library
RUN yum install -y httpd \
  && amazon-linux-extras install -y php7.2 \
  && yum install -y php-devel php-common php-mbstring php-xml php-soap php-pecl-imagick php-gd php-bcmath \
  && yum install -y  php-pear \
  && yum install -y libzip-devel \
  && bash -c "echo extension=zip.so > /etc/php.d/30-zip.ini" \
  && printf "\n" | pecl install -f redis \
  && bash -c "echo extension=redis.so > /etc/php.d/30-redis.ini" \
  && yum install -y libmcrypt-devel \
  && printf "\n" | pecl install -f mcrypt-1.0.0 \
  && bash -c "echo extension=mcrypt.so > /etc/php.d/30-mcrypt.so.ini"

# install compile tools
RUN curl -sS https://getcomposer.org/installer | php \
  && mv composer.phar /usr/local/bin/composer \
  && curl --silent --location https://rpm.nodesource.com/setup_8.x | bash - \
  && yum install -y nodejs \
  && npm rebuild node-sass

ENV COMPOSER_ALLOW_SUPERUSER 1

# install project
RUN cd /var/www \
  && rm -rf html \
  && mkdir -p /var/www/projects \
  && cd /var/www/projects \
  && git clone https://github.com/azole/laravelconf2020.git \
  && cd laravelconf2020 \
  && composer install \
  && cp .env.example .env \
  && php artisan k:g \
  && php artisan storage:link \
  && npm install \
  && npm run prod

Run ln -sfn /var/www/projects/laravelconf2020/public /var/www/html \
  && chown -R apache:apache /var/www/projects/laravelconf2020/storage \
  && cp /var/www/projects/laravelconf2020/deploy/config/apache/httpd.conf /etc/httpd/conf/httpd.conf

COPY laravel-env /var/www/projects/laravelconf2020/.env

COPY httpd-foreground /usr/local/bin/

EXPOSE 80

CMD ["httpd-foreground"]