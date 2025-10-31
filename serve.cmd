@echo off
setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
set "PORT=8000"
echo ========== Servidor estatico (http://localhost:%PORT%) ==========

rem Detectar si el puerto ya esta en uso
for /f "tokens=5" %%P in ('netstat -ano ^| findstr ":%PORT%" ^| findstr LISTENING') do set "PID=%%P"
if defined PID (
  echo Ya hay un proceso escuchando en el puerto %PORT% (PID=!PID!).
  echo Abriendo el navegador...
  start "" http://localhost:%PORT%/esqueleto.html
  goto :EOF
)

where py >nul 2>&1
if %ERRORLEVEL%==0 (
  echo Iniciando servidor con "py" en una nueva ventana...
  start "HTTP Server" cmd /c py -m http.server %PORT%
  goto :OPEN_BROWSER
)

where python >nul 2>&1
if %ERRORLEVEL%==0 (
  echo Iniciando servidor con "python" en una nueva ventana...
  start "HTTP Server" cmd /c python -m http.server %PORT%
  goto :OPEN_BROWSER
)

echo No se detecto Python. Probando con Node.js (npx http-server)...
where npx >nul 2>&1
if %ERRORLEVEL%==0 (
  start "HTTP Server" cmd /c npx -y http-server -p %PORT% -c-1
  goto :OPEN_BROWSER
)
where node >nul 2>&1
if %ERRORLEVEL%==0 (
  start "HTTP Server" cmd /c npx -y http-server -p %PORT% -c-1
  goto :OPEN_BROWSER
)

echo No se detecto Node.js en el sistema.
echo Opciones:
echo  1) Instalar Python: winget install --id Python.Python.3 --source winget
echo  2) Instalar Node.js: https://nodejs.org/en/download
echo  3) Luego ejecuta: npx -y http-server -p %PORT% -c-1
pause
exit /b 1

:OPEN_BROWSER
echo Esperando a que el servidor levante...
timeout /t 2 /nobreak >nul
echo Abriendo el navegador en esqueleto.html
start "" http://localhost:%PORT%/esqueleto.html
exit /b 0
