#!/bin/bash

LOG="/var/log/vitalinux/vx-predisplay-corregir-software.log"

echo "=> Fecha: $(date)" > ${LOG}
# if dpkg --configure -a &>> ${LOG} ; then
#   echo "=> Todo Ok" >> ${LOG}
# fi
#apt-get install -f &> /dev/null

exit 0
