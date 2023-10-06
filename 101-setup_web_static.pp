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
        try_files ${uri} ${uri}/ =404;
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
package { 'nginx':
  ensure  => installed,
  require => Exec['apt update'],
}

# Allow Nginx through the firewall
exec { 'Nginx HTTP':
  command => 'ufw allow "Nginx HTTP"',
  path    => '/usr/sbin:/usr/bin:/sbin:/bin',
  require => Package['nginx'],
}

file { '/data'
  ensure  => 'directory',
  owner   => 'ubuntu',
  group   => 'ubuntu',
}

file { '/data/web_static'
  ensure  => 'directory',
  owner   => 'ubuntu',
  group   => 'ubuntu',
  require => File["/data],
}

file { '/data/web_static/releases'
  ensure  => 'directory',
  owner   => 'ubuntu',
  group   => 'ubuntu',
  require => File["/data/web_static"],
}

file { '/data/web_static/shared'
  ensure  => 'directory',
  owner   => 'ubuntu',
  group   => 'ubuntu',
  require => File["/data/web_static"],
}

file { '/data/web_static/releases/test'
  ensure  => 'directory',
  owner   => 'ubuntu',
  group   => 'ubuntu',
  require => File["/data/web_static/releases"],
}

file { '/data/web_static/releases/test/index.html'
  ensure  => 'file',
  content => '<!DOCTYPE html>
  <html>
    <head>
    </head>
    <body>
      Holberton School
    </body>
  </html>',
  owner   => 'ubuntu',
  group   => 'ubuntu',
  require => File["/data/web_static/releases/test"],
}

file { '/data/web_static/current':
  ensure  => 'link',
  target  => '/data/web_static/releases/test',
  owner   => 'ubuntu',
  group   => 'ubuntu',
}

file { '/var/www':
  ensure  => 'directory',
  require => Package['nginx'],
  notify  => Service['nginx'],
}

file { '/var/www/html':
  ensure  => 'directory',
  require => Package['nginx'],
  notify  => Service['nginx'],
}

-file { '/var/www/html/index.html':
  ensure  => 'present',
  content => "Hello World!\n",
  require => Package['nginx'],
  notify  => Service['nginx'],
  replace => 'true',
}

file { '/var/www/html/404.html':
  ensure  => 'present',
  content => "Ceci n'est pas une page\n",
  require => Package['nginx'],
  notify  => Service['nginx'],
  replace => 'true',
}

file { '/etc/nginx/sites-available/default':
  ensure  => 'present',
  content => $nginx_config,
  require => Package['nginx'],
  notify  => Service['nginx'],
  replace => 'true',
}

# Restart Nginx
service { 'nginx':
  ensure  => running,
  enable  => true,
}
