#!/bin/sh

cat > /var/www/localhost/htdocs/.htaccess <<-'EOF'
order allow,deny
allow from all
EOF

chown -R apache:apache /var/www/localhost/htdocs
telegraf &

echo "[i] Starting daemon..."
exec httpd -DFOREGROUND
