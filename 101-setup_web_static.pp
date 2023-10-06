# Prepare web server

$nginx_config = "\
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    add_header X-Served-By ${hostname};
    root /var/www/html;
    index  index.html index.htm;
    server_name _;

    location / {
        ry_files ${uri} ${uri}/ =404;
    }

    location /redirect_me {
        return 301 https://github.com/Sallmahussien;
    }

    error_page 404 /404.html;
    location /404 {
      root /var/www/html;
      internal;
    }

    location /hbnb_static/ {
        alias /data/web_static/current/;
    }
}"

# Update packages
exec { 'apt update':
  command => 'apt-get update',
  path    => '/usr/sbin:/usr/bin:/sbin:/bin',
}

# Install Nginx
-> package { 'nginx':
  ensure  => installed,
  require => Exec['apt update'],
}

# Allow Nginx through the firewall
-> exec { 'Nginx HTTP':
  command => 'ufw allow "Nginx HTTP"',
  path    => '/usr/sbin:/usr/bin:/sbin:/bin',
  require => Package['nginx'],
}

-> file { 'data'
  ensure => 'directory',
}

-> file { '/data/web_static/'
  ensure => 'directory',
}

-> file { '/data/web_static/releases/'
  ensure => 'directory',
}

-> file { '/data/web_static/shared/'
  ensure => 'directory',
}

-> file { '/data/web_static/releases/test/'
  ensure => 'directory',
}

-> file { '/data/web_static/releases/test/index.html'
  ensure  => 'file',
  content => '<!DOCTYPE html>
  <html>
    <head>
    </head>
    <body>
      Holberton School
    </body>
  </html>',
}

-> file { '/data/web_static/current':
  ensure => 'link',
  target => '/data/web_static/releases/test'
}

-> exec { 'chown -R ubuntu:ubuntu /data/':
  path => '/usr/bin/:/usr/local/bin/:/bin/'
}

-> file { '/var/www':
  ensure => 'directory'
}

-> file { '/var/www/html':
  ensure => 'directory'
}

-> file { '/var/www/html/index.html':
  ensure  => 'present',
  content => "Hello World!\n"
}

-> file { '/var/www/html/404.html':
  ensure  => 'present',
  content => "Ceci n'est pas une page\n"
}

-> file { '/etc/nginx/sites-available/default':
  ensure  => 'present',
  content => $nginx_conf
}

# Restart Nginx
-> service { 'nginx':
  ensure  => running,
  enable  => true,
  require => [Package['nginx'], File['/etc/nginx/conf.d/custom-header.conf']],
}
