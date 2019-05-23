#!/bin/bash
#Diseñado por Arturo Martín
#Proyecto Piloto DGA

USUARIO=$(vx-usuario-grafico)
EJECUTOR=$(whoami)

FICHCONF="/etc/default/vx-dga-variables/vx-dga-variables-general.conf"

if test -f "${FICHCONF}" ; then
	. /etc/default/vx-dga-variables/vx-dga-variables-general.conf
fi
if ! [ -z "${CAMBIARHOSTNAME}" ] && test "${CAMBIARHOSTNAME}" -eq 1 && ! test -z "${NUEVOHOSTNAME}" ; then
	if vx-hostname-cli "${NUEVOHOSTNAME}" ; then
		sed -i "s/CAMBIARHOSTNAME=.*/CAMBIARHOSTNAME=0/g" "${FICHCONF}"
	fi
fi