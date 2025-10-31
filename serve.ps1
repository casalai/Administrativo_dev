param(
  [int]$Port = 8000
)

Write-Host "========== Servidor estatico (http://localhost:$Port) ==========" -ForegroundColor Cyan

function Test-Port($p){
  try { return (Test-NetConnection -ComputerName 'localhost' -Port $p -WarningAction SilentlyContinue).TcpTestSucceeded }
  catch { return $false }
}

# ¿Ya hay algo escuchando?
$pidOnPort = (Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty OwningProcess) 2>$null
if ($pidOnPort) {
  Write-Host "Ya hay un proceso escuchando en el puerto $Port (PID=$pidOnPort). Abriendo el navegador..." -ForegroundColor Yellow
  Start-Process "http://localhost:$Port/esqueleto.html"
  exit 0
}

# Intentar con 'py'
$py = (Get-Command py -ErrorAction SilentlyContinue)
if ($py) {
  Write-Host "Iniciando servidor con 'py'..." -ForegroundColor Green
  Start-Process -WindowStyle Minimized cmd -ArgumentList @('/c', "py -m http.server $Port") | Out-Null
}
elseif (Get-Command python -ErrorAction SilentlyContinue) {
  Write-Host "Iniciando servidor con 'python'..." -ForegroundColor Green
  Start-Process -WindowStyle Minimized cmd -ArgumentList @('/c', "python -m http.server $Port") | Out-Null
}
else {
  Write-Host "No se detectó Python. Probando con Node.js (npx http-server)..." -ForegroundColor Yellow
  $npx = (Get-Command npx -ErrorAction SilentlyContinue)
  $node = (Get-Command node -ErrorAction SilentlyContinue)
  if ($npx -or $node) {
    try {
      Start-Process -WindowStyle Minimized cmd -ArgumentList @('/c', "npx -y http-server -p $Port -c-1") | Out-Null
    }
    catch {
      Write-Host "Fallo al ejecutar npx http-server automáticamente." -ForegroundColor Red
      Write-Host "Puedes instalarlo globalmente: npm i -g http-server" -ForegroundColor Yellow
      Write-Host "o ejecutarlo manualmente: npx -y http-server -p $Port -c-1" -ForegroundColor Yellow
      exit 1
    }
  }
  else {
    Write-Host "No se detectó Node.js en el sistema." -ForegroundColor Red
    Write-Host "Opciones:" -ForegroundColor Yellow
    Write-Host "  1) Instalar Python: winget install --id Python.Python.3 --source winget"
    Write-Host "  2) Instalar Node.js: https://nodejs.org/en/download" 
    Write-Host "  3) Luego ejecuta: npx -y http-server -p $Port -c-1" 
    exit 1
  }
}

# Esperar a que levante
$retries = 10
while ($retries -gt 0 -and -not (Test-Port $Port)) {
  Start-Sleep -Milliseconds 500
  $retries--
}

if (Test-Port $Port) {
  Write-Host "Servidor levantado. Abriendo navegador..." -ForegroundColor Green
  Start-Process "http://localhost:$Port/esqueleto.html"
  exit 0
} else {
  Write-Host "No se pudo verificar el servidor en el puerto $Port." -ForegroundColor Red
  exit 1
}
