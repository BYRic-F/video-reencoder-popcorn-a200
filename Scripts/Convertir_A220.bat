@echo off
setlocal enabledelayedexpansion

:: =============================================
:: Script de conversion pour Popcorn Hour A-220
:: - Convertit vidéo en H.264 (1080p max)
:: - Convertit audio en AC3 stéréo
:: - Conserve les sous-titres MKV
:: =============================================

if "%~1"=="" (
    echo Glissez un fichier vidéo sur ce script pour le convertir.
    pause
    exit /b
)

set "input=%~1"
set "basename=%~n1"
set "output=%~dp0%basename%_A220.mkv"

echo.
echo =============================================
echo Conversion de : %input%
echo Vers : %output%
echo =============================================
echo.

ffmpeg -hwaccel cuda -i "%input%" ^
-map 0:v:0 -map 0:a:0 -map 0:s? ^
-vf "scale='min(1920,iw)':'min(1080,ih)':flags=lanczos" ^
-c:v h264_nvenc -preset p5 -rc vbr_hq -cq 22 -b:v 5M -pix_fmt yuv420p ^
-ac 2 -c:a ac3 -b:a 192k ^
-c:s copy -movflags +faststart ^
"%output%"

echo.
echo =============================================
echo ✅ Conversion terminee !
echo Fichier cree : %output%
echo =============================================
echo.
pause
