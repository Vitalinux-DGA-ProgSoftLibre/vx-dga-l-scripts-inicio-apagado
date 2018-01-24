#!/bin/bash

# Reconfiguramos el servicio SSH para regenerar las claves del servicio en caso de ser necesario
#  y reiniciar el servicio

if ! ( ls -l /etc/ssh/ssh_host_?sa_key &> /dev/null ) ; then
  dpkg-reconfigure openssh-server &> /dev/null
fi