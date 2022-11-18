```
Nombre      : Alejandro de Paz Hernández
```

---

# Servidor de Impresión en Windows

## Introducción 

Vamos a instalar y configurar un servidor de impresión en una máquina Windows 2016 Server. Un servidor de impresión es una herramienta que nos permita utilizar una impresora de forma remota, de forma que no necesitaremos mover el archivo físicamente ni tener la aplicación de impresión instalada en el cliente.

# 1. Impresora compartida

## 1.1 Rol impresión

Lo primero es instalar el servidor de impresión. 

* Vamos a `Agregar características o roles → Servidor de Impresión`. Dentro de los roles instalaremos la `Impresión Web` también.

![](img/1%20(22).png)

## 1.2 Instalar impresora PDF

Vamos a conectar e instalar localmente una impresora al servidor Windows Server, de modo que estén disponibles para ser accedidas por los clientes del dominio. Como no tenemos una impresora física, utilizaremos PDFCreator, un programa completamente gratuito que simula ser una impresora, de forma que nos permitirá crear archivos PDF desde cualquier aplicación.

* Descargamos PDFCreator (URL recomendada `www.pdfforge.org/pdfcreator/download`) e instalamos.

## 1.3 Probar la impresora en local

Vamos a probar la impresora de forma local imprimiendo el documento `imprimir20s-local`:

![](img/1%20(8).png)

![](img/1%20(26).png)

# 2. Compartir por red

## 2.1 En el servidor

Vamos a la MV del servidor.
* Ir al `Administrador de Impresión -> Impresoras`
* Elegir impresora PDFCreator.
    * `Botón derecho -> Propiedades -> Compartir`
    * La llamaremos `PDFAlejandro20`.

![](img/1%20(19).png)

![](img/1%20(6).png)

## 2.2 Comprobar desde el cliente

Vamos al cliente:
* Buscamos recursos de red del servidor escribiendo `\\172.19.20.21` en la barra de navegación.
* Seleccionar `Impresora -> botón derecho -> conectar` e introducimos las credenciales del servidor.

![](img/1%20(23).png)

* Ahora que hemos conectado la impresora vamos a probarla imprimiendo el documento `imprimir20s-remoto`. Al imprimir y seleccionar la impresora que hemos conectado, nos aparecerá una ventana en PDFCreator dentro del servidor que nos permitirá imprimir:

![](img/1%20(20).png)

![](img/1%20(7).png)

![](img/1%20(24).png)

# 3. Acceso Web

Realizaremos una configuración para habilitar el acceso web a las impresoras del dominio.

## 3.1 Instalar característica impresión WEB

* Vamos al servidor.
* Nos aseguramos de tener instalado el servicio "Impresión de Internet".

## 3.2 Configurar impresión WEB

En este apartado vamos a volver a agregar la impresora de red remota en el cliente, pero
usando otra forma diferente de localizar la impresora.

Vamos a la MV cliente:
* Abrimos un navegador Web.
* Ponemos URL `http://172.19.20.21/printers` para que aparezca en nuestro navegador un entorno que permite gestionar las impresoras de dicho equipo:

![](img/1%20(16).png)

![](img/1%20(1).png)


* Nos vamos a la pestaña `Propiedads` y copiamos el `Nombre de red`, ya que lo usaremos para conectar la impresora:

![](img/1%20(15).png)

* Para agregar la impresora, nos vamos a `Configuración de Windows → Dispositivos → Impresoras y escáneres → Agregar impresora o escáner`. Esto nos abrirá un asistente, donde introduciremos el `Nombre de red` que vimos anteriormente:

![](img/1%20(12).png)

![](img/1%20(13).png)

## 3.3 Comprobar desde el navegador

Vamos a realizar seguidamente una prueba sencilla en la impresora de red:
* Accedemos a la configuración de la impresora a través del navegador.
    * Ponemos en `pausa` los trabajos de impresión de la impresora.

![](img/1%20(21).png)

* Probamos la impresora remota imprimiendo el documento `imprimir20w-web`.

![](img/1%20(3).png)

* Comprobamos que, al estar la impresora en pausa, el trabajo aparece en cola de impresión del servidor.

![](img/1%20(25).png)

* Finalmente, reanudamos el trabajo para que el documento aparezca en el servidor y podamos imprimirlo.
