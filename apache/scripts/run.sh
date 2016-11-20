#!/bin/sh

# set apache as owner/group
if [ "$FIX_OWNERSHIP" != "" ]; then
        chown -R apache:apache /app
fi

echo "[i] Starting daemon..."
# run apache httpd daemon
#httpd -D FOREGROUND
exec httpd -DFOREGROUND
#while true; do sleep 1000; done

