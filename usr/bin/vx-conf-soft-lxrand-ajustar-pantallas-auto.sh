#!/bin/bash

# Cambia a la resolución deseada según parámetros establecidos en el fichero de configuración anterior
#   Tiene en cuenta si los monitores definidos estén conectados y soportan dicha resolución
#   Reinicia los servicios de PDI's que lo necesitan (iqboard e interwrite)
FICHCONF="/etc/default/vx-dga-variables/vx-dga-l-video-settings"

ACTIVE=$(crudini --get $FICHCONF Global active) || ( echo "No hay variable active...salimos"; return )
if [ "$ACTIVE" = "1" ]; then
  FORZAR="1"
  USUARIO=$(vx-usuario-grafico)
  HOMEUSU=$(getent passwd | grep "${USUARIO}" | cut -d":" -f6)
  OPERATION=$(crudini --get $FICHCONF Settings operation) || { echo "No hay variable operation...salimos"; FORZAR="0"; }
  CONNECTEDMONITORS=$(export DISPLAY=:0 && su "${USUARIO}" -c 'xrandr | grep " connected" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/"' --login)
  # Desactivamos el lanzador de interwrite para arranques futuros
  LANZADORINTERWRITE="/etc/xdg/autostart/devicemanager-autostart.desktop"
    [ -f ${LANZADORINTERWRITE} ] && \
      desktop-file-edit --add-not-show-in=LXDE "${LANZADORINTERWRITE}"
  
  if [ "$OPERATION" = "manual" ] && [ "$FORZAR" = "1" ]; then
    # Forzamos resolución según ha indicado el usuario en el fichero de configuración 
    RUTA=${HOMEUSU}/.config/autostart/lxrandr-autostart.desktop
    if test -f "$RUTA" ; then
      COMANDO=$(grep "Exec=" "${RUTA}" | awk -F "Exec=" '{ print $2 }' )
      DEFMONITORS=$(echo "$COMANDO" | grep -o "\-\-output\ [^\ ]*" | cut -d" " -f2)
      # Solo aplicaremos la configuración guardada si todos los monitores inidicados están conectados
      # Trozo de código que busca no aplicar la conf guardada
      # Haremos intentos de comprobación., con 1 segundo de espera, ya que hay monitores que no devuelven a tiempo las resoluciones...grrr
      INTENTO=0
      while [ $INTENTO -le 10 ] ; do
        ((INTENTO++))
        # Reiniciamos la variable de FORZAR ya que puede haber cambiado en un intento anterior...
        FORZAR="1"  
        for MONITOR in $DEFMONITORS; do
          RESMONITOR=$(echo "$COMANDO" | grep -o "$MONITOR\ *\-\-mode\ *[0-9x]*" | cut -d" " -f3)
          if ! [[ "$CONNECTEDMONITORS" =~ $MONITOR ]]; then
          #if ! (echo $COMANDO | grep "--output $MONITOR"); then
           echo "$(date) -  El monitor $MONITOR no está conectado. No se aplica la configuración automática"
           FORZAR="0"
           break
          fi
          RESMONITORSOPOR=$(export DISPLAY=:0 && su "${USUARIO}" -c 'xrandr | sed -n "/^'${MONITOR}'\ connected.*/,/connected/{//!p}"')
          if [ -z "RESMONITORSOPOR" ] || [ -z "RESMONITOR" ] || ! [[ "$RESMONITORSOPOR" =~ $RESMONITOR ]]; then
            echo "$(date) -  El monitor $MONITOR no soporta la resolución impuesta $RESMONITOR. No se aplica la configuración automática"
            FORZAR="0"
            break
          fi
        done
        if [ "$FORZAR" = "1" ]; then
          echo "Monitores comprobados y todo ok"
          break
        fi
        sleep 2
      done
    else
      # El fichero de resolución de usuario no existe...no forzamos
      FORZAR="0"
    fi
  elif [ "$OPERATION" = "auto" ] && [ "$FORZAR" = "1" ]; then
    # Forzamos resolución a la indcada en fichero de conf global
    RESGLOBAL=$(crudini --get $FICHCONF Settings resolution) || { echo "No hay variable resolución...salimos"; FORZAR="0"; }
    COMANDO="xrandr"
    # Tomamos un monitor cualquiera como primario:
    PMONITOR=$(echo "$CONNECTEDMONITORS" | head -1 | cut -d " " -f1)
    for MONITOR in $CONNECTEDMONITORS; do
      echo "Imponemos  ${RESGLOBAL} a ${MONITOR}"
      export DISPLAY=:0 && su "${USUARIO}" -c "xrandr --addmode ${MONITOR} ${RESGLOBAL}" --login || { echo "Ops...problemas"; FORZAR="0"; }
      [ "$MONITOR" = "$PMONITOR" ] && \
        COMANDO="${COMANDO} --output $MONITOR --mode ${RESGLOBAL}" || \
        COMANDO="${COMANDO} --output $MONITOR --mode ${RESGLOBAL} --same-as ${PMONITOR}"
    done
  else
    FORZAR="0"
  fi
  if [ "$FORZAR" = "1" ]; then
    # Es necesario reinicar el servicio para las pizarras IQBoard para que se reajuste la calibracion
    if (pgrep RSBoar &> /dev/null || pgrep RSEPServ &> /dev/null); then
      pkill RSEPService
      pkill RSBoard
      STARTRSEP=1
    fi
    # Es necesario reinciar el servicio de Interwrite si estuviera arrancado
    if ( ps -auxf | grep 'java' | grep 'DeviceManager' ) &> /dev/null ; then
      ps -auxf | grep 'java' | grep 'DeviceManager' | tr -s " " " " | cut -d" " -f2 | xargs kill -1
    fi
    while ! ( export DISPLAY=:0 && su "${USUARIO}" -c "${COMANDO}" --login ); do
          echo "--> Esperando para establecer la resolución correcta de pantalla mediante lxrandr ..."
          sleep 1
    done
    echo "$(date) - Parece que se ha ajustado la resolución de pantalla correctamente ..."
    export DISPLAY=:0 && su "${USUARIO}" -c '/usr/bin/inicio-conky &' --login > /dev/null 2>&1
    # Si hay una IQBoard, reiniciamos el servicio
    if [ "$STARTRSEP" = "1" ]; then
      export DISPLAY=:0 && su "${USUARIO}" -c '/usr/bin/RSEPService &' --login && echo "$(date) - Reiniciado el servicio de IQBoard ..."
    fi
    
    ( export DISPLAY=:0 && su "${USUARIO}" -c 'xrandr' --login | grep "\*" ) 
    echo "#-------------------------------------------------------------#"
  fi
fi
# Como hemos quitado el lanzador del arranque automático de Interw, lo arrancamos ahora
if [ -f /opt/eInstruction/DeviceManager/LinuxLauncher.sh ]; then
  ( /opt/eInstruction/DeviceManager/LinuxLauncher.sh & ) &> /dev/null
fi
