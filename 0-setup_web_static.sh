#!/usr/bin/env bash
# Prepare web servers

fake_content="\
<!DOCTYPE html>
<html>
  <head>
  </head>
  <body>
    Holberton School
  </body>
</html>
"
hbnb_static_location="\
  location /hbnb_static/ {
      alias /data/web_static/current/;
  }
"
target_folder="/data/web_static/releases/test/"
link_location="/data/web_static/current"

# Install Nginx
sudo apt-get -y update
sudo apt-get -y install nginx

# Create Project directories and files
sudo mkdir "/data"
sudo mkdir "/data/web_static/"
sudo mkdir "/data/web_static/releases/"
sudo mkdir "/data/web_static/shared/"
sudo mkdir "/data/web_static/releases/test/"
sudo touch "/data/web_static/releases/test/index.html"

# Write fake content to the index file
echo "$fake_content" | sudo tee -a /data/web_static/releases/test/index.html > /dev/null

# Create a symbolic link between two dirs
if [ -L "$link_location" ]; then
    rm "$link_location"
fi

sudo ln -sf "$target_folder" "$link_location"

# Change ownership
sudo chown -R ubuntu:ubuntu /data

# Update the Nginx configuration
sudo sed -i '40i'"${hbnb_static_location//$'\n'/\\n}" /etc/nginx/sites-available/default

# Restart service
sudo service nginx restart
