# Análisis estático con SonarQube

Proyectos analizados (6): `servicio-auth`, `servicio-usuarios`, `servicio-citas`,
`servicio-historial`, `servicio-pacientes-java`, `optica-frontend`.

## Requisitos

- Docker
- JDK 17 en el PATH (`java -version`)
- Los servicios backend traen Maven Wrapper (`mvnw` / `mvnw.cmd`); no hace falta Maven.

## 1. Levantar SonarQube

```bash
docker run -d --name sonarqube -p 9000:9000 sonarqube:lts-community
```

Espera ~1 min, entra a http://localhost:9000 (usuario `admin`, contraseña `admin`;
te pedirá cambiarla).

Genera un token: avatar (arriba a la derecha) → **My Account → Security → Generate Tokens**.

- Para **escanear**: tipo *Global Analysis Token*.
- Para **generar los reportes** del paso 3: tipo *User Token* (el de análisis no puede leer la API).

## 2. Escanear los 6 proyectos

Windows (PowerShell):

```powershell
.\tools\sonar-scan.ps1 -Token TU_TOKEN
```

Linux / macOS:

```bash
./tools/sonar-scan.sh TU_TOKEN
```

Resultados en http://localhost:9000.

> Nota: se usa `-DskipTests` (los tests `contextLoads()` necesitan MySQL/Kafka/Mongo).
> No hay cobertura; para tenerla habría que levantar la infra y correr `verify` con JaCoCo.
> En SonarQube 9.9 la propiedad del token es `sonar.login` (no `sonar.token`).

## 3. (Opcional) Reportes descargables DOCX / XLSX / MD / CSV

Con un *User Token*:

```powershell
.\tools\generate-reports.ps1 -Token TU_USER_TOKEN
```

```bash
./tools/generate-reports.sh TU_USER_TOKEN
```

Descarga cnesreport 4.3.0 la primera vez y deja un reporte por proyecto en `reports/<proyecto>/`.
Esa carpeta es la que puedes comprimir y enviar.
