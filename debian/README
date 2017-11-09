# Paquete DEB vx-dga-l-scripts-inicio-apagado

Paquete encargado de configurar los scripts que se ejecutarán en tres momentos concretos:

* Scripts que se ejectuarán antes de cargarse el Greeter (pantalla de autenticación de usuario, login/password)
Esto es posible gracias a lightdm, que ofrece esta posibilidad:
```
display-setup-script=/usr/bin/vx-scripts-predisplay
```
Localizándose la lista de scripts que se ejecutarán en:
```
/usr/share/vitalinux/predisplay.d/*.sh
```

* Scripts que se ejecutarán al iniciar la sesión gráfica
Esto es posible gracias al ***xdg/autostart***, y se ejecutará la lista de scripts que estén ubicados en:
```
/usr/share/vitalinux/prerun.d/*.sh
```

* Scripts que se ejectuarán al cerrarse la sesión gráfica.
Esto es posible gracias a lightdm, que ofrece esta posibilidad:
```
display-stopped-script=/usr/bin/vx-scripts-apagado
```
Localizándose la lista de scripts que se ejecutarán en:
```
/usr/share/vitalinux/postrun.d/*.sh
```

# Usuarios/Equipos Destinatarios

Todos los equipos Vitalinux con la finalidad de poder configurar su compartamiento en los tres momentos descritos anteriormente.

# Aspectos Interesantes
```
Ninguno en concreto
```

# Como Crear el paquete DEB a partir del codigo de GitHub
Para crear el paquete DEB será necesario encontrarse dentro del directorio donde localizan los directorios que componen el paquete.  Una vez allí, se ejecutará el siguiente comando (es necesario tener instalados los paquetes apt-get install debhelper devscripts):

```
apt-get install debhelper devscripts
/usr/bin/debuild --no-tgz-check -us -uc
```
En el caso de que no desees crear el paquete DEB a partir del código fuente, ya que no más a modificarlo ni introducir ninguna mejora, puedes obtener el paquete DEB aquí:

[Listado de Paquetes del Proyecto de Software Libre](http://migasfree.educa.aragon.es/repo/Lubuntu-14.04/STORES/base/)

# Como Instalar el paquete generado vx-dga-l-*.deb:
Para la instalación de paquetes que estan en el equipo local puede hacerse uso de ***dpkg*** o de ***gdebi***, siendo este último el más aconsejado para que se instalen también las dependencias correspondientes.
```
gdebi vx-dga-l-*.deb
```
