@echo off
chcp 65001 1>nul 2>nul
pushd "%~sdp0"

if exist "%CD%\__temp_cache" ( 
  del /f /s "%CD%\__temp_cache\*.*"
  rmdir /s "%CD%\__temp_cache\."
  mkdir "%CD%\__temp_cache" 1>nul 2>nul
) 

pause 1>&2
popd
exit /b 0
