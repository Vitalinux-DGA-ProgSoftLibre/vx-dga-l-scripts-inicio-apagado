# Establacemos como fondo de pantalla el base (o el de su centro) en la postinstalación
if [ -f $_FIRST ] ; then
	if [ -f /usr/bin/obtener-resolucion-pantalla ] && \
		[ -f /usr/share/vitalinux/wallpapers/vitalinux-edu-wallpaper-4x3-1600x1200.png ] && \
		 [ -f /usr/share/vitalinux/wallpapers/vitalinux-edu-wallpaper-16x9-1920x1080.png ]; then

		RESOLUCION=$(/usr/bin/obtener-resolucion-pantalla)
		if test "$RESOLUCION" == "" ; then
			echo "=> $(date) - Se ha detectado una resolución de pantalla Indeterminada ..."
			RESOLUCION="Indeterminada"
		else
			echo "=> $(date) - Se ha detectado una resolución de pantalla de $RESOLUCION ..."
		fi
		_FILE1=/usr/share/vitalinux/wallpapers/vitalinux-edu-wallpaper.png
		_FILE2=/usr/share/vitalinux/wallpapers/vitalinux-login.png

		case $RESOLUCION in
			"4:3" )
			if cp  /usr/share/vitalinux/wallpapers/vitalinux-edu-wallpaper-4x3-1600x1200.png $_FILE1 && \
				cp  /usr/share/vitalinux/wallpapers/vitalinux-login-4x3-1600x1200.png $_FILE2 ; then
				echo "=> $(date) - Se configurado los Wallpapers para la resolución de 4:3 ..."
			else
				echo "=> $(date) - Se iba a configurar los Wallpapers para la resolución de 4:3 y ha habido algún problema con la creación de los enlaces simbólicos ..."
			fi
			;;
			"16:9" )
			if cp  /usr/share/vitalinux/wallpapers/vitalinux-edu-wallpaper-16x9-1920x1080.png $_FILE1 && \
				cp  /usr/share/vitalinux/wallpapers/vitalinux-login-16x9-1920x1080.png $_FILE2 ; then
				echo "=> $(date) - Se configurado los Wallpapers para la resolución de 16:9 ..."
			else
				echo "=> $(date) - Se iba a configurar los Wallpapers para la resolución de 16:9 y ha habido algún problema con la creación de los enlaces simbólicos ..."
			fi
			;;
			* )
			if cp  /usr/share/vitalinux/wallpapers/vitalinux-edu-wallpaper-16x9-1920x1080.png $_FILE1 && \
				cp  /usr/share/vitalinux/wallpapers/vitalinux-login-16x9-1920x1080.png $_FILE2 ; then
				echo "=> $(date) - Se configurado los Wallpapers para la resolución de 16:9 a pesar de que la resolución es $RESOLUCION ..."
			else
				echo "=> $(date) - Se iba a configurar los Wallpapers para la resolución de 16:9 a pesar de que la resolución es $RESOLUCION y ha habido algún problema con la creación de los enlaces simbólicos ..."
			fi
			;;
		esac
		for WALL in /usr/share/vitalinux/wallpapers/*; do
        	chmod +r $WALL
    	done
		# Aplicamos la configuración en el momento para que se refleje en el instante
	    USUARIOGRAF=$(vx-usuario-grafico)
	    su -c "pcmanfm -w /usr/share/vitalinux/wallpapers/vitalinux-edu-wallpaper.png" --login $USUARIOGRAF
	else
		echo "=> $(date) - Error Fondo Imagen: No existen /usr/bin/obtener-resolucion-pantalla o los ficheros base ..."
	fi

fi

