#!/bin/bash
/sbin/start-stop-daemon --start --quiet -m \
 --name vx-xrandr \
 --pidfile /run/vx-xrandr.pid \
 -b --no-close \
 -a /usr/bin/vx-conf-soft-lxrand-ajustar-pantallas-auto.sh