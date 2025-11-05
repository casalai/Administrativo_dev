Param(
    [switch]$Login,
    [string]$NodeVersion = 'v20.18.0'
)

$ErrorActionPreference = 'Stop'

$zip = Join-Path $env:TEMP ("node-" + $NodeVersion + ".zip")
$dest = Join-Path $env:USERPROFILE ("node-portable-" + $NodeVersion)
$base = Join-Path $dest ("node-" + $NodeVersion + "-win-x64")
$node = Join-Path $base 'node.exe'
$npm  = Join-Path $base 'node_modules/npm/bin/npm-cli.js'

function Ensure-PortableNode {
  if (-not (Test-Path $node)) {
    Write-Host "Descargando Node $NodeVersion..."
    $url = "https://nodejs.org/dist/" + $NodeVersion + "/node-" + $NodeVersion + "-win-x64.zip"
    Invoke-WebRequest -Uri $url -OutFile $zip -UseBasicParsing
    if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
    New-Item -ItemType Directory -Path $dest | Out-Null
    Expand-Archive -Path $zip -DestinationPath $dest -Force
    Write-Host "Node extraído en: $base"
  }
}

function Ensure-FirebaseTools {
  if (-not (Test-Path (Join-Path (Get-Location) 'node_modules/firebase-tools/lib/bin/firebase.js'))) {
    Write-Host "Instalando firebase-tools local..."
    & $node $npm install firebase-tools --no-fund --no-audit --save-dev | Write-Host
  }
}

Ensure-PortableNode
Ensure-FirebaseTools

$firebase = Join-Path (Get-Location) 'node_modules/firebase-tools/lib/bin/firebase.js'

if ($Login) {
  & $node $firebase login --reauth
  exit $LASTEXITCODE
}

Write-Host "Desplegando a Firebase (hosting + reglas)..."
& $node $firebase deploy --only hosting,firestore:rules,storage --project sistema-productividad-equipo --non-interactive
exit $LASTEXITCODE
