#!/bin/sh

echo "=========================================="
echo "Updating APT package manager"
echo "=========================================="
apt-get -qq update


echo "=========================================="
echo "Installing apache with APT package manager"
echo "=========================================="
apt-get install -y apache2


echo "=========================================="
echo "Linking host's CWD to guest's /var/ww"
echo "=========================================="
rm -rf /var/www
ln -fs /vagrant /var/www

echo "=========================================="
echo "HTML/JS files in host CWD are now accessible via apache"
echo "=========================================="
