 # 0. Introducción VNC

VNC o Computación Virtual en Red es un software libre que permite crear un entorno cliente-servidor de forma que el cliente pueda ver y controlar la máquina servidor de forma remota. Es posible hacerlo incluso entre máquinas con SSOO distinto, como veremos a continuación. En esta práctica vamos a utilizar 4 máquinas distintas, dos máquinas Windows y dos máquinas OpenSuse. En mi caso, he utilizado dos máquinas reales con Windows 11 y Windows 10 (mi portátil y el sobremesa de un familiar) ya que las máquinas virtuales con Windows iban extremadamente mal en VirtualBox.

## 0.2 Configuraciones

Vamos a montar un entorno como el siguiente: 

| MV | OS       | IP           | Rol        | Detalles              |
| -- | -------- | ------------ | ---------- | --------------------- |
|  1 | Windows 11 | 192.168.1.49 | Slave VNC  | Instalar servidor VNC |
|  2 | Windows 10 | 192.168.1.62 | Master VNC | Instalar cliente VNC  |
|  3 | OpenSUSE | 192.168.1.69 | Slave VNC  | Instalar servidor VNC |
|  4 | OpenSUSE | 192.168.1.71 | Master VNC | Instalar cliente VNC  |

**NOTA: (Las IPs que he utilizado han sido estas ya que he realizado la práctica en casa. Por eso y porque he utilizado máquinas reales, me he saltado las configuraciones de las máquinas Windows y las configuraciones de red de las máquinas OpenSuse)**

# 1. Windows: Slave VNC

* Descargamos `TightVNC` desde la página oficial.
* En el servidor VNC, es decir, la MV Windows 11 instalaremos `TightVNC -> Custom -> Server`. Esto es el servicio.

![](img/3.png)

* Establecemos una contraseña para la conexión remota:

![](img/4.png)


* En caso de errores, revisar el cortafuegos de Windows.


## 1.2 Ir a una máquina con GNU/Linux

* Ejecutamos `nmap -Pn 192.168.1.49`, desde la máquina real para comprobar
que los servicios son visibles desde fuera de la máquina VNC-SERVER. Vemos que VNC está escuchando desde los puertos 5800 y 5900:

![](img/7.png)


# 2 Windows: Master VNC

* En el cliente Windows seguimos los pasos anteriores pero esta vez instalamos `TightVNC -> Custom -> Viewer`.

* Ejecutamos `TightVNC Viewer`, el cliente VNC e introducimos la IP de la máquina que queremos visualizar que, en este caso, es 192.168.1.49

![](img/9.png)

* Vemos que podemos visualizar y manipular la máquina server:

![](img/10.png)

## 2.1 Comprobaciones finales

* Para verificar que se han establecido las conexiones remotas vamos al servidor VNC y utilizamos el comando `netstat -n` para ver las conexiones VNC con el cliente. Vemos que las IPs coinciden y la conexión está en estado ESTABLISHED

![](img/11.png)


# 3. OpenSUSE: Slave VNC

* Establecemos la configuración inicial editando los ficheros `/etc/hosts` y `/etc/hostname` (He saltado la configuración de red y la he dejado en DHCP ya que estoy usando la red de casa):

![](img/13.png)

![](img/19.png)

* Vamos a `Yast -> VNC`
    * Permitimos conexión remota, que configura el servicio `xinet`.
    * Abrimos los puertos VNC en el cortafuegos.

![](img/14.png)

* Ir a `Yast -> Cortafuegos`
    * Revisamos la configuración del cortafuegos.
    * Vemos que están permitidas las conexiones a VNC.

![](img/15.png)

* Con el usuario `alejandro`:
    * Ejecutamos `vncserver` en el servidor para iniciar el servicio VNC.
    * Ponemos claves para las conexiones VNC a nuestro escritorio.
    * Al final se nos muestra el número de nuestro escritorio remoto. Lo utilizaremos más adelante para realizar la conexión.

![](img/16.png)

* `vdir /home/alejandro/.vnc`, vemos que se nos han creado unos ficheros de configuración VNC asociados a nuestro usuario.

![](img/17.png)

* Ejecutamos `ps -ef|grep vnc` para comprobar que los servicios relacionados con vnc están en ejecución.
* Ejecutamos `lsof -i -nP` para comprobar que están los servicios en los puertos VNC (5802 y 5902).

![](img/18.png)


## 3.1 Ir a una máquina GNU/Linux

* Ejecutamos `nmap -Pn 192.168.1.69`, desde una máquina GNU/Linux para comprobar que los servicios son visibles desde fuera de la máquina VNC-SERVER. Deben verse los puertos VNC (5802, 5902, etc).

![](img/20.png)

---

# 4. OpenSUSE: Master VNC
* Realizamos la configuración inicial al igual que en la máquina anterior. El nombre de esta será `depaz20g2` y la configuración de red:

![](img/28.png)

* En OpenSuse `vncviewer` viene instalado por defecto, a diferencia de Windows.
* En la conexión remota, tenemos que especificar el puerto por el que realizaremos la conexión. En nuestro caso será el puerto 5901.
* Hay varias formas de usar vncviewer, nosotros usaremos la primera:
    * `vncviewer IP-vnc-server:590N`
    * `vncviewer IP-vnc-server:N`
    * `vncviewer IP-vnc-server::590N`

![](img/22.png)

## 4.1 Comprobaciones finales

Una vez conectados a la máquina servidor, ejecutamos lo siguiente desde la misma:

* `lsof -i -nP` para comprobar las conexiones VNC.

![](img/23.png)

* `vncserver -list` para ver la lista de sesiones abiertas.

![](img/24.png)

---

# 5. Comprobaciones con SSOO cruzados

A continuación, vamos a comprobar la conexión entre los SSOO de forma cruzada, es decir, de OpenSuse a Windows y de Windows a OpenSuse:

* Conectamos el cliente GNU/Linux con el Servidor VNC Windows.
Usaremos el comando `vncviewer 192.168.1.49` sin especificar puerto alguno.

![](img/25.png)

* Introducimos la contraseña y estaremos dentro de la máquina Windows:

![](img/26.png)

* Ejecutamos `netstat -n` en el servidor Windows para comprobar que, efectivamente, se ha realizado la conexión y que las IPs están correctas. Podemos ver además que la conexión realizada anteriormente entre las máquinas Windows aparece como TIME_WAIT (ha finalizado):

![](img/27.png)

* Conectamos el cliente Windows con el servidor VNC GNU/Linux. En este caso, tendremos que especificar el puerto.

![](img/34.png)

* Ejecutarmos en el servidor GNU/Linux `lsof -i -nP` para comprobar que se ha realizado la conexión (Cabe destacar que al realizar este paso yo ya había realizado el siguiente punto (punto 6) donde activamos el control de la pantalla local):

![](img/35.png)

---

# 6. DISPLAY 0 en GNU/Linux

Cuando queremos ejecutar VNC en GNU/Linux para controlar directamente la pantalla local usaremos el comando `x0vncserver`.
* Vamos a usar las 2 MV GNU/Linux.
* Vamos al servidor y ejectuamos `x0vncserver -display :0 -passwordfile /home/nombre-alumno/.vnc/passwd`. Este comando habilitará el despliegue de la pantalla para el VNC Master, y activará la solicitud la contraseña almacenada en `/home/nombre-alumno/.vnc/passwd`. Vemos además que está utilizando el puerto 5900.

![](img/30.png)

* Vamos al cliente y usamos nmap para comprobar que el puerto 5900 del servidor 
está abierto.

![](img/31.png)

* Probamos a conectarnos con el servidor a través del puerto 5900(`vncviewer 192.168.1.69:5900`).

![](img/32.png)


* Ejecutamos `lsof -i -nP` en el server.

![](img/33.png)

