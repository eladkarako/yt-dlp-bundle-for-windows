@echo off
chcp 65001 1>nul 2>nul
pushd "%~sdp0"

if exist "%CD%\__logs" ( 
  del /f /s "%CD%\__logs\*"
)

pause 1>&2
popd
exit /b 0
