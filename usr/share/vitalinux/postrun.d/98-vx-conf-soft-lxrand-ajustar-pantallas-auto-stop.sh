#!/bin/bash
# Matamos por si acaso cuando se cierre la sesión el demonio que configura las pantallas
# Por si se ha quedado intentando imponer la resolución
/sbin/start-stop-daemon --oknodo --stop --pidfile /run/vx-xrandr.pid --retry=TERM/10/KILL/5
