@echo off

::------------------------------------------------------------------------
chcp 65001 1>nul 2>nul
set "LANG=en_US.UTF-8"
set "LANGUAGE=en_US"
set "LC_ALL=en_US.UTF-8"
set "LC_ADDRESS=en_US.UTF-8"
set "LC_COLLATE=en_US.UTF-8"
set "LC_CTYPE=en_US.UTF-8"
set "LC_IDENTIFICATION=en_US.UTF-8"
set "LC_MEASUREMENT=en_US.UTF-8"
set "LC_MESSAGES=en_US.UTF-8"
set "LC_MONETARY=en_US.UTF-8"
set "LC_NAME=en_US.UTF-8"
set "LC_NUMERIC=en_US.UTF-8"
set "LC_PAPER=en_US.UTF-8"
set "LC_TELEPHONE=en_US.UTF-8"
set "LC_TIME=en_US.UTF-8"
set "TZ=UTC"
::------------------------------------------------------------------------


::------------------------------------------------------------------------
set "FOLDER_TARGET=%CD%"
::------------------------------------------------------------------------


::------------------------------------------------------------------------
pushd "%~sdp0"
set "FOLDER_OWN=%CD%"
popd
::------------------------------------------------------------------------


::------------------------------------------------------------------------
set "TIMESTAMP="
for /F "usebackq delims=" %%E IN (`call "node.exe" "%FOLDER_OWN%\js\timestamp.js" 2^>nul`) do ( 
  set "TIMESTAMP=%%E"
  goto EXIT_LOOP_TIMESTAMP
) 
:EXIT_LOOP_TIMESTAMP
::------------------------------------------------------------------------


::------------------------------------------------------------------------
set "PATH=%FOLDER_OWN%\aria2c;%PATH%"
set "PATH=%FOLDER_OWN%\AtomicParsley;%PATH%"
set "PATH=%FOLDER_OWN%\curl;%PATH%"
set "PATH=%FOLDER_OWN%\ffmpeg;%PATH%"
set "PATH=%FOLDER_OWN%\node;%PATH%"
set "PATH=%FOLDER_OWN%\yt-dlp;%PATH%"

set "TEMP=%FOLDER_OWN%\__temp_cache"
set "TMP=%TEMP%"
::------------------------------------------------------------------------




::------------------------------------------------------------------------
set "ARGS="
set  ARGS=%ARGS% "%FOLDER_OWN%\yt-dlp\yt-dlp.exe"
set  ARGS=%ARGS% --ignore-config
set  ARGS=%ARGS% --config-locations "%FOLDER_OWN%\__yt_dlp__config.txt"
set  ARGS=%ARGS% --download-archive "%FOLDER_OWN%\__yt_dlp__archive_history.txt"
::set  ARGS=%ARGS% --cookies "%FOLDER_OWN%\__cookies_youtube.txt"
set  ARGS=%ARGS% --paths "home:%FOLDER_TARGET%"
set  ARGS=%ARGS% --paths "temp:%TEMP%"
set  ARGS=%ARGS% --cache-dir "%TEMP%"

set  ARGS=%ARGS% %*

set  ARGS=%ARGS:\=/%
::------------------------------------------------------------------------


::------------------------------------------------------------------------
mkdir "%FOLDER_OWN%\__temp_cache" 1>nul 2>nul
mkdir "%FOLDER_OWN%\__logs" 1>nul 2>nul
::------------------------------------------------------------------------


set "FILE_LOG=%FOLDER_OWN%\__logs\__log__%TIMESTAMP%.txt"


::------------------------------------------------------------------------
echo.[INFO] %TIMESTAMP%  1>&2
echo.[INFO] %ARGS%       1>&2
echo.                    1>&2

::------------------------------------------------------------------------
echo. 1>"%FILE_LOG%"
::------------------------------------------------------------------------

echo.[INFO] %TIMESTAMP% 1>>"%FILE_LOG%"
echo.[INFO] %ARGS%      1>>"%FILE_LOG%"
echo.                   1>>"%FILE_LOG%"

::set "ALL_PROXY=socks5h://127.0.0.1:9150"

"node.exe" "%FOLDER_OWN%\js\tee.js" "%FILE_LOG%" %ARGS%
set "EXIT_CODE=%ErrorLevel%"

echo.[INFO] EXIT_CODE: %EXIT_CODE% 1>&2

echo. 1>>"%FILE_LOG%"
echo.EXIT_CODE: %EXIT_CODE% 1>>"%FILE_LOG%"


pause 1>&2
exit /b %EXIT_CODE%



::-----------------------------------------------------------------------------------
:: main entry point you should use when using this bundle project.
:: it is a wrap around "yt-dlp.exe"
:: that handles dependencies awareness
:: configuration and paths,
:: and running via "tee.js".
::-----------------------------------------------------------------------------------