param([Parameter(Mandatory = $true)][string]$Token)

$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
$jar  = Join-Path $PSScriptRoot "sonar-cnes-report.jar"
$out  = Join-Path $root "reports"
$cnesUrl = "https://github.com/cnescatlab/sonar-cnes-report/releases/download/4.3.0/sonar-cnes-report-4.3.0.jar"

if (-not (Test-Path $jar)) {
    Write-Host "Descargando cnesreport 4.3.0..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri $cnesUrl -OutFile $jar
}

$projects = "servicio-auth", "servicio-usuarios", "servicio-citas", "servicio-historial", "servicio-pacientes-java", "optica-frontend"
foreach ($p in $projects) {
    Write-Host "=== $p ===" -ForegroundColor Cyan
    $pout = Join-Path $out $p
    New-Item -ItemType Directory -Force -Path $pout | Out-Null
    java -jar $jar -s http://localhost:9000 -t $Token -p $p -o $pout -a "Equipo Optica"
}

Write-Host "Reportes (.docx / .xlsx / .md / .csv) en $out" -ForegroundColor Green
