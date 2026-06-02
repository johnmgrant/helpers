#!/bin/bash

echo "Setting directory permissions for /var/www/html/..."
sudo find /var/www/html/ -type d -exec chmod 775 {} \;

echo "Setting file permissions for /var/www/html/..."
sudo find /var/www/html/ -type f -exec chmod 664 {} \;

echo "Setting group ID on directories in /var/www/html/..."
sudo find /var/www/html/ -type d -exec chmod g+s {} \;

echo "Changing ownership to www-data for /var/www/html/..."
sudo chown -R www-data:www-data /var/www/html/

echo "Restarting Apache to apply changes..."
sudo systemctl restart apache2

echo "Permissions and ownership have been set for /var/www/html/."