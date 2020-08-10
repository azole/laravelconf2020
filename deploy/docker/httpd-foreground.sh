#!/bin/sh
set -e

php-fpm -D

# Apache gets grumpy about PID files pre-existing
rm -f /run/httpd/httpd.pid

exec httpd -DFOREGROUND