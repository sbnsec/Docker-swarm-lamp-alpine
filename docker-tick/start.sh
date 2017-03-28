#!/bin/bash
set -m

kapacitord -config /etc/kapacitor/kapacitor.conf &
influxd -config /etc/influxdb/influxdb.conf &
service chronograf start

sleep 10
influx -execute 'CREATE DATABASE "tick_ddb"'
influx -execute "CREATE USER "tick_user" WITH PASSWORD 'tick_pwd'"
influx -execute 'GRANT ALL ON tick_ddb TO tick_user'
influx -execute 'CREATE RETENTION POLICY thirty_days ON tick_ddb DURATION 30d REPLICATION 1 DEFAULT'
/bin/bash
#fg
#/usr/bin/supervisord
