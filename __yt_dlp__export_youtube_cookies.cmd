@echo off
chcp 65001 1>nul 2>nul

set "BROWSER_PROFILE_PATH=firefox:D:/software/browser/tor/Browser/TorBrowser/Data/Browser/w43yss2l.default"

echo [INFO] removing old cookies file (__cookies_youtube.txt) 1>&2
del /f /q "%~sdp0\__cookies_youtube.txt"

echo. 1>&2

echo [INFO] exporting all cookies (__cookies_all.txt) 1>&2
call "%~sdp0\yt-dlp\yt-dlp.exe" --verbose --ignore-errors --cookies-from-browser "%BROWSER_PROFILE_PATH%" --cookies "%~sdp0\__cookies_all.txt" 2>nul

echo. 1>&2

echo [INFO] keeping just google and youtube related cookies (__cookies_youtube.txt)... 1>&2
echo.# Netscape HTTP Cookie File>"%~sdp0\__cookies_youtube.txt"
echo.>>"%~sdp0\__cookies_youtube.txt"
type "%~sdp0\__cookies_all.txt" | findstr /i /r /c:"^\.youtube" /c:"^\.google" /c:"^consent\.youtube" /c:"consent\.google">>"%~sdp0\__cookies_youtube.txt"
echo.>>"%~sdp0\__cookies_youtube.txt"

echo. 1>&2

::------------------------------------------------------------------------
set "LINES_IN_FILE_COOKIE_YOUTUBE_TXT="
for /F "usebackq delims=" %%E IN (`call type "%~sdp0\__cookies_youtube.txt" ^| find /c /v "" 2^>nul`) do ( 
  set /a "LINES_IN_FILE_COOKIE_YOUTUBE_TXT=%%E - 4"
  goto EXIT_LOOP_LINES_IN_FILE_COOKIE_YOUTUBE_TXT
) 
:EXIT_LOOP_LINES_IN_FILE_COOKIE_YOUTUBE_TXT
::------------------------------------------------------------------------

echo [INFO] got %LINES_IN_FILE_COOKIE_YOUTUBE_TXT% cookies (__cookies_youtube.txt)... 1>&2

echo. 1>&2

echo [INFO] cleanup (__cookies_all.txt).. 1>&2
del /f /q "%~sdp0\__cookies_all.txt"

echo. 1>&2

echo [INFO] done. 1>&2
pause
exit /b 0
