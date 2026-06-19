@echo off
chcp 65001 1>nul 2>nul
pushd "%~sdp0"
set "FOLDER_OWN=%CD%"
popd
call "%FOLDER_OWN%\__yt-dlp.cmd" --batch-file %*
exit /b %ErrorLevel%


::--------------------------------------------------------------------------
:: accepts first argument as a text file somewhere with links to download
::--------------------------------------------------------------------------