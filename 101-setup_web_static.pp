# Prepare web servers

exec { 'update_packages':
  command => 'apt-get -y update',
}

exec { 'install_nginx':
  command => 'apt-get -y install nginx',
  require => Exec['update_packages'],
}

exec { 'create_directories':
  command => 'mkdir -p /data/web_static/releases/test/ /data/web_static/shared/',
}

exec { 'create_index_file':
  command => 'echo "<!DOCTYPE html>
<html>
  <head>
  </head>
  <body>
    Holberton School
  </body>
</html>" | tee -a /data/web_static/releases/test/index.html > /dev/null',
  require => Exec['create_directories'],
}

exec { 'create_symbolic_link':
  command => 'ln -sf /data/web_static/releases/test/ /data/web_static/current',
  unless  => 'test -L /data/web_static/current',
  require => Exec['create_index_file'],
}

exec { 'change_ownership':
  command => 'chown -R ubuntu:ubuntu /data',
  require => Exec['create_symbolic_link'],
}

exec { 'update_nginx_configuration':
  command => "sed -i '40i location /hbnb_static/ {\n    alias /data/web_static/current/;\n}' /etc/nginx/sites-available/default",
  require => Exec['change_ownership'],
}

exec { 'restart_nginx':
  command     => 'service nginx restart',
  refreshonly => true,
  subscribe   => Exec['update_nginx_configuration'],
}
