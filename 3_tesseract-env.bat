@echo off
setlocal enabledelayedexpansion

:: 1. Definimos las rutas absolutas basadas en el usuario
set "DEST_BACKEND=%USERPROFILE%\label-studio-ml-backend\label_studio_ml\examples\tesseract"
set "DATA_FOLDER=%USERPROFILE%\mydata"

echo ==================================================
echo      CONFIGURADOR ROBUSTO - TALLER OCR 2026
echo ==================================================
echo.

:: 2. Verificamos si existe la carpeta del backend
if not exist "%DEST_BACKEND%" (
    echo [ERROR] No se encuentra la carpeta del Backend en:
    echo "%DEST_BACKEND%"
    echo.
    echo Asegurate de haber clonado el repositorio correctamente.
    pause
    exit /b
)

:: 3. Procesar el archivo env.txt -> .env
if exist "%~dp0env.txt" (
    echo [PASO 1] Configurando el archivo .env...
    copy /y "%~dp0env.txt" "%DEST_BACKEND%\.env" >nul
    echo [OK] Archivo .env colocado en el destino correcto.
) else (
    echo [AVISO] No se encontro 'env.txt' en esta carpeta.
)

:: 4. Procesar el archivo docker-compose.yml
if exist "%~dp0docker-compose.yml" (
    echo [PASO 2] Actualizando configuracion Docker Compose...
    copy /y "%~dp0docker-compose.yml" "%DEST_BACKEND%\docker-compose.yml" >nul
    echo [OK] docker-compose.yml actualizado.
) else (
    echo [AVISO] No se encontro 'docker-compose.yml' en esta carpeta.
)

:: 5. Crear carpeta de datos si no existe (por si acaso)
if not exist "%DATA_FOLDER%" (
    echo [PASO 3] Creando carpeta de datos %DATA_FOLDER%...
    mkdir "%DATA_FOLDER%"
    echo [OK] Carpeta creada.
)

echo.
echo --------------------------------------------------
echo   CONFIGURACION COMPLETADA CON EXITO
echo --------------------------------------------------
echo  Ahora puedes ir a la carpeta:
echo  %DEST_BACKEND%
echo  Y ejecutar: docker compose up -d
echo --------------------------------------------------
echo.
pause