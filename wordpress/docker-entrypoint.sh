#!/bin/sh

cat > .htaccess <<-'EOF'
  # BEGIN WordPress
  <IfModule mod_rewrite.c>
  RewriteEngine On
  RewriteBase /
  RewriteRule ^index\.php$ - [L]
  RewriteCond %{REQUEST_FILENAME} !-f
  RewriteCond %{REQUEST_FILENAME} !-d
  RewriteRule . /index.php [L]
  </IfModule>
  # END WordPress
EOF
chown www-data:www-data .htaccess

# set apache as owner/group
if [ "$FIX_OWNERSHIP" != "" ]; then
        chown -R apache:apache /app
fi

echo "[i] Starting daemon..."
# run apache httpd daemon
#httpd -D FOREGROUND
exec httpd -DFOREGROUND
#while true; do sleep 1000; done


