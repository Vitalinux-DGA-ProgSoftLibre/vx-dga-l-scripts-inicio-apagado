#!/bin/bash

if ! test "$(whoami)" == "root" ; then
	echo "$(date) - Debes ser el root para ejecutar este programa ..." | tee -a /tmp/vx-modificar-usuarios.log
	exit 1
fi	

if ! test -d "/var/log/vitalinux" ; then
	mkdir -p /var/log/vitalinux
fi

LOG="/var/log/vitalinux/vx-modificar-usuarios.log"

function modificar-usuario {
	OLDNOMBRE="$1"
	NEWNOMBRE="$2"
	OLDHOME="$3"
	NEWHOME="$4"
	NEWCOMMENT="$5"
	if ( getent passwd | grep "${OLDNOMBRE}:" &> /dev/null ) ; then
		echo "$(date) - Se va a modificar el usuario \"${OLDNOMBRE}\" por \"${NEWNOMBRE}\" ..." >> ${LOG}
		/usr/sbin/usermod -l "${NEWNOMBRE}" \
			-c "${NEWCOMMENT}" "${OLDNOMBRE}" &>> ${LOG}
		if test -d "${OLDHOME}" ; then
			if mv "${OLDHOME}" "${NEWHOME}" ; then
				echo "$(date) - Se va a modificar el HOME \"${OLDHOME}\" por \"${NEWHOME}\" ..." >> ${LOG}
				/usr/sbin/usermod -d "${NEWHOME}" "${NEWNOMBRE}" &>> ${LOG}
			fi
		fi
		if grep "autologin-user=${OLDNOMBRE}" &> /dev/null ; then
			sed -i "s/autologin-user=${OLDNOMBRE}/autologin-user=${NEWNOMBRE}/g" /etc/lightdm/lightdm.conf
		fi
		if grep "^${OLDNOMBRE}" /etc/sudoers.d/permisos &> /dev/null ; then
			sed -i "s/^${OLDNOMBRE}/${NEWNOMBRE}/g" /etc/sudoers.d/permisos
		fi
	fi
}

if test -f /usr/bin/migasfree-tags ; then
	ETIQUETAS="$(sudo migasfree-tags -g | tr -s '"' ' ')"
	# echo "=> Las etiquetas Migasfree del equipo son: ${ETIQUETAS}"
fi

if ( echo "${ETIQUETAS}" | grep "NOMBRE-ETIQUETA-CENTRO" &> /dev/null ) ; then
modificar-usuario "profesor" "profesorado" "/home/profesor" "/home/profesorado" "Profesorado del Centro"
modificar-usuario "alumno" "alumnado" "/home/alumno" "/home/alumnado" "Alumnado del Centro"
modificar-usuario "dga" "RyC" "/home/dga" "/home/RyC" "RyC Administrador"
fi

# Para evitar que se vuelva a intentar ejecutar esta tarea
## chmod 000 /usr/share/vitalinux/predisplay.d/91-vx-renombrar-usuarios.sh

exit 0