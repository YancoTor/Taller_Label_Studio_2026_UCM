@echo off
set "REPO_URL=https://github.com/HumanSignal/label-studio-ml-backend"
set "FOLDER_NAME=label-studio-ml-backend"
set "DEST_PATH=%USERPROFILE%"

echo ==================================================
echo      INSTALADOR INTELIGENTE - ML BACKEND
echo ==================================================
echo.

:: 1. Verificación de Git
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Git no esta instalado en este sistema.
    echo Por favor, instalalo primero: https://git-scm.com/
    pause
    exit /b
)

:: 2. Cambiar a la carpeta del usuario
cd /d "%DEST_PATH%"

:: 3. COMPROBACION CRITICA: ¿Ya existe la carpeta?
if exist "%FOLDER_NAME%\" (
    echo [INFO] La carpeta '%FOLDER_NAME%' ya existe en:
    echo %DEST_PATH%
    echo.
    echo [OK] No es necesario descargar nada. El taller puede continuar.
    echo --------------------------------------------------
    goto :final
)

:: 4. Si no existe, procedemos a clonar
echo [INFO] No se ha encontrado el repositorio. 
echo [INFO] Iniciando descarga desde GitHub...
echo.

git clone %REPO_URL%

if %errorlevel% equ 0 (
    echo.
    echo [EXITO] Repositorio descargado correctamente en:
    echo %DEST_PATH%\%FOLDER_NAME%
) else (
    echo.
    echo [ERROR] Hubo un problema con la descarga. 
    echo Comprueba tu conexion a internet.
)

:final
echo.
echo Presiona cualquier tecla para salir...
pause >nul