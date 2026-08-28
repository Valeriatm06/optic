#!/usr/bin/env bash
set -euo pipefail

TOKEN="${1:?Uso: ./tools/generate-reports.sh <user-token>}"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$DIR/.." && pwd)"
JAR="$DIR/sonar-cnes-report.jar"
OUT="$ROOT/reports"
CNES_URL="https://github.com/cnescatlab/sonar-cnes-report/releases/download/4.3.0/sonar-cnes-report-4.3.0.jar"

if [ ! -f "$JAR" ]; then
  echo "Descargando cnesreport 4.3.0..."
  curl -sL -o "$JAR" "$CNES_URL"
fi

for p in servicio-auth servicio-usuarios servicio-citas servicio-historial servicio-pacientes-java optica-frontend; do
  echo "=== $p ==="
  mkdir -p "$OUT/$p"
  java -jar "$JAR" -s http://localhost:9000 -t "$TOKEN" -p "$p" -o "$OUT/$p" -a "Equipo Optica"
done

echo "Reportes (.docx / .xlsx / .md / .csv) en $OUT"
