#!/bin/bash

cp init.d_remsht_local /etc/init.d/remsht_local
chmod 700 /etc/init.d/remsht_local
chkconfig remsht_local on

cp remsht_local.gawk /usr/local/sbin/
chmod 600 /usr/local/sbin/remsht_local.gawk

cp remsht /usr/local/sbin
chmod 700 /usr/local/sbin/remsht

cp logrotate_remsht_local /etc/logrotate.d/remsht_local
chmod 644 /etc/logrotate.d/remsht_local

touch /var/log/remsht.log
