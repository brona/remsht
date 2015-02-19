remsht
======

Simple server and client application for remote server shutdown over serial port (RS-232). Usable  especially integrated with [apcupsd](http://www.apcupsd.com). Designed to have no required dependencies on [XenServer 6.5](http://xenserver.org).

Typical use case is for apcupsd compatible UPS with USB interface connected to one server (master), where apcupsd is configured to shutdown hypervisor or anything else in VM world in case of power outage. And then you have second server (slave) which you would like to shutdown too. Problem is you have only embedded RS-232 interfaces available.

Shutdown authentication is provided by sha1 digest over secret and timestamp. Working time synchronisation is needed.

**Warning**: Use this software after careful consideration. remsht was never meant to be used in production environment.

**Keywords**: Linux,Shell,gawk,serial,shutdown,apcupsd,RS-232,UART,XenServer.

## Slave server
Slave server is listening on serial port waiting to authenticated shutdown command. Server is realised using `(cat /dev/ttyS0 | gawk ... ) &` method, e.g. detached piped commands.

All input lines longer then 1000 characters are ignored. Inputs are sanitised before used in shell commands.

* Clone repository.
* `init.d_remsht_local` is provided for automatic startup.
* `logrotate_remsht_local` is provided to clean up log file.
* Edit `remsht_local.gawk`
    * Change secret on line #12
    * Uncomment shutdown command on line #39
* Edit `init.d_remsht_local`
    * Change `serline` to desired `ttyS0`
* Run `install.sh` or manualy copy scripts and files to suitable directories (don't forget to `touch /var/log/remsht.log`).
* Run `service remsht_local start`
* Watch `tail -f /var/log/remsht.log` to see incoming comands.

## Master server

* Clone repository
* Edit `remsht`
    * Change secret
    * Change `serline` to desired `ttyS0`
* `cp remsht /usr/local/sbin/`
* Run `remsht` to shutdown Slave server


## apcupsd integration
To configure master server to shutdown slave server once UPS reports low remaining battery level create  `/etc/apcupsd/doshutdown` with this content:

    #!/bin/bash
    /usr/local/sbin/remsht
    exit 0

To install apcupds on XenServer 6.5 you need to manually download and install two rpms (Download 64bit CentOS 5 versions at [pkgs.org](http://pkgs.org)):

    rpm -i mailx-8.1.1-44.2.2.x86_64.rpm
    rpm -i apcupsd-3.14.10-1.el5.x86_64.rpm

Please configure this packages responsibly.

## Authors

* Bronislav Robenek <brona@robenek.me>

## License

* The MIT License (MIT)
