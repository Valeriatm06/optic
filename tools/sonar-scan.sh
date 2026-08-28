#!/usr/bin/env bash
set -euo pipefail

TOKEN="${1:?Uso: ./tools/sonar-scan.sh <token>}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
URL="http://localhost:9000"
PLUGIN="org.sonarsource.scanner.maven:sonar-maven-plugin:3.11.0.3922:sonar"

for s in servicio-auth servicio-usuarios servicio-citas servicio-historial servicio-pacientes-java; do
  echo "======== $s ========"
  ( cd "$ROOT/backend/$s" && ./mvnw -B clean compile "$PLUGIN" -DskipTests \
      -Dsonar.host.url="$URL" -Dsonar.login="$TOKEN" \
      -Dsonar.projectKey="$s" -Dsonar.projectName="$s" )
done

echo "======== optica-frontend ========"
( cd "$ROOT/frontend/optica-app/frontend" && docker run --rm -v "$(pwd):/usr/src" \
    -e SONAR_HOST_URL="http://host.docker.internal:9000" \
    -e SONAR_TOKEN="$TOKEN" \
    sonarsource/sonar-scanner-cli )

echo "Listo. Resultados en $URL"
