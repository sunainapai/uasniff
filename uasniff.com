server {
    listen 80;

    server_name uasniff.com uasniff;

    return 301 https://$server_name$request_uri;

}

server {

    # SSL configuration

    server_name uasniff.com uasniff;
    listen 443 ssl;
    include snippets/ssl_uasniff.com.conf;

    location ~ /.well-known {
        allow all;
    }

    root /var/www/uasniff;
    index index.html;

    location / {
        try_files $uri @yourapplication;
    }

    location /static {
        root /var/www/uasniff;
    }

    location @yourapplication {
        include uwsgi_params;
        uwsgi_pass unix:/tmp/uasniff_uwsgi.sock;
    }
}
