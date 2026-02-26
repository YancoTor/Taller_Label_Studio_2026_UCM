@echo off
set "TESS_PATH=%USERPROFILE%\label-studio-ml-backend\label_studio_ml\examples\tesseract"
:: Tenemos dos versiones, si estamos usando también la versión con yolo, la carpeta final no es tesseract, sino tesseract_and_yolo
:: El resto debería ser lo mismo, porque tienen la misma lógica

echo ==================================================
echo      LANZADOR DE BACKEND: TESSERACT OCR
echo ==================================================
echo.

:: 1. Comprobar si la carpeta existe
if not exist "%TESS_PATH%" (
    echo [ERROR] No se encuentra la carpeta del backend en:
    echo "%TESS_PATH%"
    echo.
    echo Asegurate de haber clonado el repositorio primero.
    goto :error
)

:: 2. Comprobar si Docker está encendido
echo [INFO] Verificando que Docker Desktop este abierto...
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Docker no esta respondiendo. 
    echo Por favor, ABRE DOCKER DESKTOP y espera a que la ballena este verde.
    goto :error
)

:: 3. Comprobar si el archivo docker-compose.yml existe en la ruta
if not exist "%TESS_PATH%\docker-compose.yml" (
    echo [ERROR] No se encuentra el archivo 'docker-compose.yml' en la carpeta.
    echo Revisa si el script de configuracion movio los archivos correctamente.
    goto :error
)

:: 4. Entrar y Arrancar
echo [OK] Todo listo. Arrancando servidor...
echo [INFO] Para detener el servidor, pulsa CTRL+C o cierra esta ventana.
echo.
cd /d "%TESS_PATH%"

:: Ejecutamos docker compose sin -d para ver los logs
docker compose up

echo.
echo [INFO] El servidor se ha detenido.
goto :final

:error
echo.
echo --------------------------------------------------
echo EL PROCESO NO PUDO INICIAR. Revisa los errores arriba.
echo --------------------------------------------------
:final

pause
