#!/bin/sh

sudo -u www-data sh <<eof
    . /home/sunaina/.venv/uasniff/bin/activate
    uwsgi --ini uasniff_uwsgi.ini
eof
