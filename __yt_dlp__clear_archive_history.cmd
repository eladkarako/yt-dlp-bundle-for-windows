@echo off
chcp 65001 1>nul 2>nul
pushd "%~sdp0"
set "FOLDER_OWN=%CD%"
popd
if exist "%FOLDER_OWN%\__yt_dlp__archive_history.txt" ( 
  copy /v "%FOLDER_OWN%\__yt_dlp__archive_history.txt" "%FOLDER_OWN%\__yt_dlp__archive_history.txt.old"
) 
echo.>"%FOLDER_OWN%\__yt_dlp__archive_history.txt"
pause 1>&2
exit /b 0
