param([Parameter(Mandatory = $true)][string]$Token)

$ErrorActionPreference = "Stop"
$root     = Split-Path $PSScriptRoot -Parent
$sonarUrl = "http://localhost:9000"
$plugin   = "org.sonarsource.scanner.maven:sonar-maven-plugin:3.11.0.3922:sonar"

$services = "servicio-auth", "servicio-usuarios", "servicio-citas", "servicio-historial", "servicio-pacientes-java"
foreach ($s in $services) {
    Write-Host "======== $s ========" -ForegroundColor Cyan
    Push-Location (Join-Path $root "backend\$s")
    & .\mvnw.cmd -B clean compile $plugin -DskipTests `
        "-Dsonar.host.url=$sonarUrl" "-Dsonar.login=$Token" `
        "-Dsonar.projectKey=$s" "-Dsonar.projectName=$s"
    Pop-Location
}

Write-Host "======== optica-frontend ========" -ForegroundColor Cyan
Push-Location (Join-Path $root "frontend\optica-app\frontend")
docker run --rm -v "${PWD}:/usr/src" `
    -e SONAR_HOST_URL="http://host.docker.internal:9000" `
    -e SONAR_TOKEN="$Token" `
    sonarsource/sonar-scanner-cli
Pop-Location

Write-Host "Listo. Resultados en $sonarUrl" -ForegroundColor Green
