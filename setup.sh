#!/bin/sh

# If any command fails, let the script fail.
set -e -x

mkdir -p ~/git
cd ~/git

! [ -d alpha ] && git clone https://github.com/sunainapai/uasniff.git

cd ~/git/alpha/proj/uasniff
git pull

[ -d /var/www/uasniff ] && mv /var/www/uasniff /tmp/uasniff-delete
mkdir /var/www/uasniff
cp ~/git/alpha/proj/uasniff/uasniff.py /var/www/uasniff
cp -r ~/git/alpha/proj/uasniff/templates /var/www/uasniff
cp -r ~/git/alpha/proj/uasniff/static /var/www/uasniff
cp ~/git/alpha/proj/uasniff/uasniff.com /var/www/uasniff
cp ~/git/alpha/proj/uasniff/uasniff_uwsgi.ini /var/www/uasniff
! [ -d /etc/nginx/snippets ] && sudo mkdir /etc/nginx/snippets
sudo cp ~/git/alpha/proj/uasniff/ssl_uasniff.com.conf /etc/nginx/snippets/ssl_uasniff.com.conf
sudo chown -R www-data:www-data /var/www/uasniff
sudo find /var/www/uasniff -type d -exec chmod 770 {} \;
sudo find /var/www/uasniff -type f -exec chmod 660 {} \;
# Why this sudo is needed? I have noticed 'Operation not permitted if
# the script is run a second time.
sudo rm -rf /tmp/uasniff-delete

# nginx-uwsgi-flask
python3 -m venv ~/.venv/uasniff
. ~/.venv/uasniff/bin/activate
pip install flask
pip install uwsgi

sudo cp /var/www/uasniff/uasniff.com /etc/nginx/sites-available/uasniff.com
sudo ln -sf /etc/nginx/sites-available/uasniff.com /etc/nginx/sites-enabled
ls -l /etc/nginx/sites-enabled

sudo service nginx restart
sudo service nginx status

sudo mkdir -p /var/log/uwsgi
sudo chown -R www-data:www-data /var/log/uwsgi
