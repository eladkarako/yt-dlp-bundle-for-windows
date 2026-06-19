@echo off
chcp 65001 1>nul 2>nul
pushd "%~sdp0"
set "FOLDER_OWN=%CD%"
popd
if not exist "%FOLDER_OWN%\__yt_dlp__list.txt" ( 
  echo.>"%FOLDER_OWN%\__yt_dlp__list.txt"
)
call "%FOLDER_OWN%\__yt_dlp__list.cmd" "%FOLDER_OWN%\__yt_dlp__list_local.txt" %*
exit /b %ErrorLevel%


::-----------------------------------------------------------------------------------
:: uses a specific local text file in yt-dlp bundle project, named __yt_dlp__list.txt
::-----------------------------------------------------------------------------------