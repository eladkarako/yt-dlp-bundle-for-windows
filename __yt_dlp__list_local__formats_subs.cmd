@echo off
chcp 65001 1>nul 2>nul
pushd "%~sdp0"
set "FOLDER_OWN=%CD%"
popd
call "%FOLDER_OWN%\__yt_dlp__list.cmd" --simulate --list-formats --list-subs
exit /b %ErrorLevel%


::-----------------------------------------------------------------------------------
:: does not download anything. instead, query formats and subtitles for all links
:: in the specific text file (in yt-dlp bundle project), named __yt_dlp__list.txt
::-----------------------------------------------------------------------------------