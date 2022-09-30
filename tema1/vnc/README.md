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

**NOTA: (Las IPs que he utilizado han sido estas ya que he realizado la práctica en casa. Por eso y porque he utilizado máquinas reales, me he saltado las configuraciones de las máquinas Windows.)**

# 1. Windows: Slave VNC

* Descargarmos `TightVNC` desde la página oficial.
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

* En el cliente Windows instalamos `TightVNC -> Custom -> Viewer`.
* Ejecutamos `TightVNC Viewer`, el cliente VNC e introducimos la IP de la máquina que queremos visualizar que, en este caso, es 192.168.1.49

![](img/9.png)


![](img/10.png)

## 2.1 Comprobaciones finales

Para verificar que se han establecido las conexiones remotas:
* Conectar desde Window Master hacia el Windows Slave.
* Ir al servidor VNC y usar el comando `netstat -n` para ver las conexiones VNC con el cliente.

---

# 3. OpenSUSE: Slave VNC

* Configurar las máquinas virtuales según este [documento](../../global/configuracion/).
* Ir a `Yast -> VNC`
    * Permitir conexión remota. Esto configura el servicio `xinet`.
    * Abrir puertos VNC en el cortafuegos.
* Ir a `Yast -> Cortafuegos`
    * Revisar la configuración del cortafuegos.
    * Debe estar permitido las conexiones a `vnc-server`.

> NOTA: Podemos parar completamente el cortafuegos usando el comando `systemctl stop firewalld`.
Pero lo recomendable es tener el cortafuegos en ejecución y abrir solamente los puertos que vayamos a necesitar.

* Con nuestro usuario normal
    * Ejecutar `vncserver` en el servidor para iniciar el servicio VNC.
        * Otra opción `vncserver -interfaz [address]`.
    * Ponemos claves para las conexiones VNC a nuestro escritorio.
    * Al final se nos muestra el número de nuestro escritorio remoto.
    Apuntar este número porque lo usaremos más adelante.
* `vdir /home/nombrealumno/.vnc`, vemos que se nos han creado unos ficheros de configuración VNC asociados a nuestro usuario.
* Ejecutar `ps -ef|grep vnc` para comprobar que los servicios relacionados con vnc están en ejecución.
* Ejecutar `lsof -i -nP` para comprobar que están los servicios en los puertos VNC (580X y 590X).

> NOTA: En OpenSUSE GNU/Linux el comando `netstat -ntap` está obsoleto. Pero si aún insistimos en usarlo... tendremos que instalar el paquete `net-tools-deprecated`. Lo recomendado es usar el comando `lsof`.

## 3.1 Ir a una máquina GNU/Linux

* Ejecutar `nmap -Pn IP-VNC-SERVER`, desde una máquina GNU/Linux para comprobar que los servicios son visibles desde fuera de la máquina VNC-SERVER. Deben verse los puertos VNC (5801, 5901, etc).

---

# 4. OpenSUSE: Master VNC

* `vncviewer` es un cliente VNC que viene con OpenSUSE.
* En la conexión remota, hay que especificar `IP:5901`, `IP:5902`, etc.
(Usar el número del escritorio remoto obtenido anteriormente).
* Hay varias formas de usar vncviewer:
    * `vncviewer IP-vnc-server:590N`
    * `vncviewer IP-vnc-server:N`
    * `vncviewer IP-vnc-server::590N`


## 4.1 Comprobaciones finales

Comprobaciones para verificar que se han establecido las conexiones remotas:
* Conectar desde GNU/Linix Master hacia GNU/Linux Slave.
    * Si tenemos problemas, cerrar la sesión en la máquina Slave,
    antes de iniciar la sesión desde la máquina Master.
* Ejecutar como superusuario `lsof -i -nP` en el servidor para comprobar las conexiones VNC.
* Ejecutar `vncserver -list` en el servidor.

---

# 5. Comprobaciones con SSOO cruzados

* Conectar el cliente GNU/Linux con el Servidor VNC Windows.
Usaremos el comando `vncviewer IP-vnc-server` sin especificar puerto alguno.
* Ejecutar `netstat -n` en el servidor Windows.
* Conectar el cliente Windows con el servidor VNC GNU/Linux.
* Ejecutar en el servidor GNU/Linux `lsof -i -nP`.

---

# 6. DISPLAY 0 en GNU/Linux

> [Enlace de interés](https://wiki.archlinux.org/index.php/TigerVNC_)

Cuando queremos ejecutar VNC en GNU/Linux para controlar directamente la pantalla local usaremos el comando `x0vncserver`.
* Vamos a usar las 2 MV GNU/Linux.
* Ir al servidor.
* `x0vncserver -display :0 -passwordfile /home/nombre-alumno/.vnc/passwd`. Para más información, véase `man x0vncserver`
* Ir al cliente. Usar nmap para comprobar que el puerto 5900 del servidor está abierto.
* Probar a conectarnos con el servidor (`vncviewer IP-VNC-SERVER:5900`).
* `lsof -i -nP`.
