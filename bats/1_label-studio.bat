@echo off
set IMAGE_NAME=heartexlabs/label-studio:latest
:: RUTA DEFINITIVA (Donde tienes la DB buena y la subcarpeta 101)
set DATA_PATH=C:\Users\yanco\label_studio_data

echo ==================================================
echo       GESTOR DE INSTALACION: LABEL STUDIO
echo ==================================================
echo.

:: 1. Comprobar si la imagen ya existe localmente
docker image inspect %IMAGE_NAME% >nul 2>&1

if %errorlevel% neq 0 (
    echo [INFO] La imagen no esta instalada.
    echo [INFO] Descargando Label Studio por primera vez...
    echo.
    docker pull %IMAGE_NAME%
) else (
    echo [OK] Label Studio ya esta listo para arrancar.
)

echo.
echo [INFO] Iniciando el contenedor...
echo [INFO] Tus datos estan en: %DATA_PATH%
echo [INFO] Acceso a archivos locales: ACTIVADO
echo [INFO] Base de datos: CARGADA
echo.
echo --------------------------------------------------
echo  ATENCION: No cierres esta ventana mientras trabajes.
echo  Ve a http://localhost:8080 en tu navegador.
echo --------------------------------------------------
echo.

:: 2. Ejecutar el contenedor
:: -e LABEL_STUDIO_LOCAL_FILES_SERVING_ENABLED=true -> Permite ver las fotos en el navegador
:: -e LABEL_STUDIO_BASE_DATA_DIR=/label-studio/data -> Fuerza a buscar la DB en la carpeta montada
:: -v mapea tu carpeta 'label_studio_data' al directorio interno '/label-studio/data'
:: No sé yo... antes: -e LABEL_STUDIO_BASE_DATA_DIR=/label-studio/data
docker run --rm -it ^
  --name label-studio ^
  -p 8080:8080 ^
  -e LABEL_STUDIO_LOCAL_FILES_SERVING_ENABLED=true ^
  -e LABEL_STUDIO_LOCAL_FILES_DOCUMENT_ROOT=/label-studio/data ^
  -v "%DATA_PATH%:/label-studio/data" ^
  %IMAGE_NAME%

echo.
echo [INFO] Label Studio se ha detenido correctamente.
pause