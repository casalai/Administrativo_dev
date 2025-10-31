# Instrucciones para pruebas locales

Este proyecto incluye `esqueleto.html` que carga otras páginas del repositorio en pestañas.

Requisitos
- Windows PowerShell
- Python 3 o Node.js (cualquiera de los dos para servir archivos localmente)

Iniciar servidor local (opciones)

Opción A) Con los scripts incluidos (recomendado)
1. Abre PowerShell y navega a la carpeta del proyecto:

```powershell
cd 'c:\Users\Admin\Administrativo_dev'
```

2. Ejecuta uno de estos comandos:

Con PowerShell (intenta Python y, si no hay, usa Node con npx http-server):

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\serve.ps1
```

Con CMD/PowerShell clásico (.bat, también funciona .cmd):

```powershell
./serve.bat
```

Esto abrirá automáticamente http://localhost:8000/esqueleto.html si el puerto está libre. Los scripts prueban en este orden: Python (py/python) y luego Node (npx http-server).

Opción B) Manual

Si tienes Python:

```powershell
python -m http.server 8000
```

Si tienes Node:

```powershell
npx -y http-server -p 8000 -c-1
```

Luego abre en el navegador:

http://localhost:8000/esqueleto.html

Alternativa rápida: doble clic en `serve.bat` o `serve.cmd`.
Ambos intentan Python; si no está, arrancan con Node (npx http-server). Si no tienes ninguno, los scripts te indican cómo instalar.

Notas
- Algunas páginas incluyen JS que necesita ejecutarse en su propio contexto; por eso `esqueleto.html` carga esas páginas dentro de iframes.
- Si ves mensajes como "El documento tardó demasiado en cargar", sirve los archivos con el servidor local o abre la página en una pestaña nueva.

Problemas comunes
- fetch o iframes en `file://` pueden fallar por políticas de seguridad del navegador. Usa `http://localhost` para evitarlo.
- Si tienes dudas, copia y pega aquí los errores de la consola del navegador (F12 -> Consola) y te ayudo a debuggear.
