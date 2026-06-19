@echo off
chcp 65001 1>nul 2>nul

::-----------------------------------
:: yt-dlp dependencies and updater.
::-----------------------------------

setlocal

::------------------------------------------------------------------------------------------------
pushd "%~sdp0"
goto MAIN
::------------------------------------------------------------------------------------------------

::------------------------------------------------------------------------------------------------
:CURL_OVER_TOR
  echo. 1>&2
  echo. 1>&2
  title %~1
  echo [INFO] request URL:    [%~1]   1>&2
  echo [INFO] force filename: [%~2]   1>&2
  set "ARGS="
  set  ARGS=%ARGS% --disable
  set  ARGS=%ARGS% --verbose
  set  ARGS=%ARGS% --remote-time
  set  ARGS=%ARGS% --location-trusted
  set  ARGS=%ARGS% --insecure
  set  ARGS=%ARGS% --anyauth
  set  ARGS=%ARGS% --tlsv1.2
  set  ARGS=%ARGS% --ssl-no-revoke
  set  ARGS=%ARGS% --ssl-revoke-best-effort
  set  ARGS=%ARGS% --doh-insecure
  ::set  ARGS=%ARGS% --socks5-hostname "127.0.0.1:9150"
  set  ARGS=%ARGS% --proxy "socks5h://127.0.0.1:9150"
  set  ARGS=%ARGS% --noproxy "localhost,127.0.0.1,::1,192.168.0.0/24,10.0.0.0/24"
  set  ARGS=%ARGS% --resolve "github.com:443:140.82.112.6"
  set  ARGS=%ARGS% --resolve "github.com:443:140.82.114.3"
  set  ARGS=%ARGS% --resolve "raw.githubusercontent.com:443:185.199.111.133"
  set  ARGS=%ARGS% --resolve "release-assets.githubusercontent.com:443:185.199.108.133"
  set  ARGS=%ARGS% --resolve "release-assets.githubusercontent.com:443:185.199.109.133"
  set  ARGS=%ARGS% --resolve "release-assets.githubusercontent.com:443:185.199.110.133"
  set  ARGS=%ARGS% --resolve "release-assets.githubusercontent.com:443:185.199.111.133"
  set  ARGS=%ARGS% --resolve "security.cloudflare-dns.com:443:1.1.1.2"
  set  ARGS=%ARGS% --resolve "security.cloudflare-dns.com:443:1.0.0.2"
  set  ARGS=%ARGS% --resolve "security.cloudflare-dns.com:443:[2606:4700:4700::1112]"
  set  ARGS=%ARGS% --resolve "security.cloudflare-dns.com:443:[2606:4700:4700::1002]"
  set  ARGS=%ARGS% --doh-url "https://security.cloudflare-dns.com/dns-query"
  set  ARGS=%ARGS% --url "%~1"
  if ["%~2"] neq [""] ( 
    set  ARGS=%ARGS% --output-dir "%CD%"
    set  ARGS=%ARGS% --output "%~2"
    title %~2
  )
  ::set "HTTP_PROXY=http://127.0.0.1:9150"
  ::set "HTTPS_PROXY=http://127.0.0.1:9150"
  set "ALL_PROXY=socks5h://127.0.0.1:9150"
  set "NO_PROXY=localhost,127.0.0.1,::1,192.168.0.0/24,10.0.0.0/24"
  echo. 1>&2
  call "curl.exe" %ARGS%
  set "EXIT_CODE=%ErrorLevel%"
  set "HTTP_PROXY="
  set "HTTPS_PROXY="
  set "ALL_PROXY="
  set "NO_PROXY="
  echo [INFO] CURL ended with EXIT_CODE: %EXIT_CODE% 1>&2
  goto :eof
::------------------------------------------------------------------------------------------------


:MAIN
  ::--- be very careful. the following lines will forcefully close any instances of curl,yt-dlp,node,etc.. running on your computer! even ones which are not the ones specific from this folder.
  "taskkill.exe" /F /IM "7za.exe"           /T
  "taskkill.exe" /F /IM "AtomicParsley.exe" /T
  "taskkill.exe" /F /IM "aria2c.exe"        /T
  "taskkill.exe" /F /IM "curl.exe"          /T
  "taskkill.exe" /F /IM "node.exe"          /T
  "taskkill.exe" /F /IM "ffmpeg.exe"        /T
  "taskkill.exe" /F /IM "ffprobe.exe"       /T
  "taskkill.exe" /F /IM "yt-dlp.exe"        /T



  if exist ".\curl\curl.exe" ( 
    echo [INFO] found "curl.exe"
  ) else ( 
    mkdir "curl" 1>nul 2>nul
    pushd "curl"
    where "curl.exe" 1>nul 2>nul
    if ["%ErrorLevel%"] equ ["0"] ( 
      call :CURL_OVER_TOR "https://gist.github.com/user-attachments/assets/2608cebc-47a7-4774-8437-621367a3642c" "curl.exe"
    ) else ( 
      "powershell.exe" -NoProfile Invoke-WebRequest -MaximumRedirection 2 -Uri "https://gist.github.com/user-attachments/assets/2608cebc-47a7-4774-8437-621367a3642c" -OutFile "curl.exe"
    ) 
    del /f /q "__readme_curl.old.txt"  1>nul 2>nul
    ren "__readme_curl.txt" "__readme_curl.old.txt"  1>nul 2>nul
    "curl.exe" --help all 1>"__readme_curl.txt" 2>&1
    popd
  ) 


  set "PATH=%CD%\curl;%PATH%"


  if exist ".\7za\7za.exe" ( 
      echo [INFO] found "7za.exe", skipping download. 1>&2
  ) else (
    mkdir "7za" 1>nul 2>nul
    pushd "7za"
    call :CURL_OVER_TOR "https://gist.github.com/user-attachments/assets/c4bb95e1-6a9a-464e-9096-631ebebd8b1f" "7za.exe"
    del /f /q "__readme_7za.old.txt"  1>nul 2>nul
    ren "__readme_7za.txt" "__readme_7za.old.txt"  1>nul 2>nul
    "7za.exe" --version  1>"__readme_7za.txt" 2>&1
    "7za.exe" --help    1>>"__readme_7za.txt" 2>&1
    "7za.exe" i         1>>"__readme_7za.txt" 2>&1
    popd
  ) 


  set "PATH=%CD%\7za;%PATH%"



::  if exist ".\tee\tee.exe" ( 
::      echo [INFO] found "tee.exe", skipping download. 1>&2
::  ) else (  
::    mkdir "tee" 1>nul 2>nul
::    pushd "tee"
::    call :CURL_OVER_TOR "https://gist.github.com/user-attachments/assets/5da006bb-a9f4-492b-9a0b-aad079ed77b4" "tee.zip"
::    move "tee.zip" "%TEMP%"
::    pushd "%TEMP%"
::    "7za.exe" e -y "tee.zip"
::    popd
::    move "%TEMP%\tee.exe"           ".\"
::    move "%TEMP%\unix2dos.exe"      ".\"
::    move "%TEMP%\msys-2.0.dll"      ".\"
::    move "%TEMP%\msys-iconv-2.dll"  ".\"
::    move "%TEMP%\msys-intl-8.dll"   ".\"
::    del /f /q "__readme_tee.old.txt"  1>nul 2>nul
::    ren "__readme_tee.txt" "__readme_tee.old.txt"  1>nul 2>nul
::    "tee.exe" --help  1>"__readme_tee.txt" 2>&1
::    del /f /q "__readme_unix2dos.old.txt"  1>nul 2>nul
::    ren "__readme_unix2dos.txt" "__readme_unix2dos.old.txt"  1>nul 2>nul
::    "unix2dos.exe" --help  1>"__readme_unix2dos.txt" 2>&1
::    popd
::  ) 


::  if exist ".\wget\wget.exe" ( 
::      echo [INFO] found "wget.exe", skipping download. 1>&2
::  ) else (  
::    mkdir "wget" 1>nul 2>nul
::    pushd "wget"
::    call :CURL_OVER_TOR "https://eternallybored.org/misc/wget/1.21.4/64/wget.exe" "wget.exe"
::    del /f /q "__readme_wget.old.txt"  1>nul 2>nul
::    ren "__readme_wget.txt" "__readme_wget.old.txt"  1>nul 2>nul
::    "wget.exe" --help  1>"__readme_wget.txt" 2>&1
::    popd
::  ) 



  if exist ".\node\node.exe" ( 
    echo [INFO] found "node.exe", skipping download. 1>&2
  ) else ( 
    mkdir "node" 1>nul 2>nul
    pushd "node"
    set "NODEJS_LATEST_NIGHTLY_BUILD_WIN64="
    for /F "usebackq delims=" %%E IN (`call "curl.exe" --disable --silent --location --max-redirs 1 --ipv4 --proxy "socks5h://127.0.0.1:9150" --header "Range: bytes=0-2048" --url "https://nodejs.org/download/nightly/index.tab"  2^>nul ^| "findstr.exe" /i /c:"win-x64" 2^>nul`) do ( 
        for /F "usebackq tokens=1 delims=	" %%A IN ('%%E') do ( 
            set "NODEJS_LATEST_NIGHTLY_BUILD_WIN64=%%A"
            goto EXIT_LOOP_NODEJS_LATEST_NIGHTLY_BUILD_WIN64
        ) 
    ) 
    :EXIT_LOOP_NODEJS_LATEST_NIGHTLY_BUILD_WIN64
    call :CURL_OVER_TOR "https://nodejs.org/download/nightly/%NODEJS_LATEST_NIGHTLY_BUILD_WIN64%/win-x64/node.exe" "node.exe"
    del /f /q "__readme_node.old.txt"  1>nul 2>nul
    ren "__readme_node.txt" "__readme_node.old.txt"  1>nul 2>nul
    "node.exe" --version  1>"__readme_node.txt" 2>&1
    "node.exe" --help    1>>"__readme_node.txt" 2>&1
    popd
  )



  set "PATH=%CD%\node;%PATH%"



  if exist ".\js\unix2dos.js" ( 
      echo [INFO] found "unix2dos.js", skipping download. 1>&2
  ) else (  
    mkdir "js" 1>nul 2>nul
    pushd "js"
    call :CURL_OVER_TOR "https://gist.github.com/eladkarako/54f0a5a36d532580b37b269f77ba1f1d/raw/unix2dos.js" "unix2dos.js"
    "node.exe" "unix2dos.js" "unix2dos.js"
    popd
  ) 
  

  if exist ".\js\tee.js" ( 
      echo [INFO] found "tee.js", skipping download. 1>&2
  ) else (  
    mkdir "js"
    pushd "js"
    call :CURL_OVER_TOR "https://gist.github.com/eladkarako/1d21d34615d9ee2bff69536a8ab4865f/raw/tee.js" "tee.js"
    "node.exe" "unix2dos.js" "tee.js"
    popd
  ) 


  if exist ".\js\timestamp.js" ( 
      echo [INFO] found "timestamp.js", skipping download. 1>&2
  ) else (  
    mkdir "js" 1>nul 2>nul
    pushd "js"
    call :CURL_OVER_TOR "https://gist.github.com/eladkarako/950cd72bea9bcb33a5214419dbb86217/raw/timestamp.js" "timestamp.js"
    "node.exe" "unix2dos.js" "timestamp.js"
    popd
  ) 



::  if exist ".\jq\jq.exe" ( 
::      echo [INFO] found "7za.exe", skipping download. 1>&2
::  ) else ( 
::    mkdir "jq" 1>nul 2>nul
::    pushd "jq"
::    call :CURL_OVER_TOR "https://github.com/jqlang/jq/releases/latest/download/jq-win64.exe" "jq.exe"
::    del /f /q "__readme_jq.old.txt"  1>nul 2>nul
::    ren "__readme_jq.txt" "__readme_jq.old.txt"  1>nul 2>nul
::    "7za.exe" --version  1>"__readme_jq.txt" 2>&1
::    "7za.exe" --help    1>>"__readme_jq.txt" 2>&1
::    popd
::  ) 



::  if exist ".\aria2c\aria2c.exe" ( 
::      echo [INFO] found "aria2c.exe", skipping download. 1>&2
::  ) else ( 
::    mkdir "aria2c" 1>nul 2>nul
::    pushd "aria2c"
::    call :CURL_OVER_TOR "https://gist.github.com/user-attachments/assets/68de99a4-6944-4993-8242-3645245d7800" "aria2c.exe"
::    del /f /q "__readme_aria2c.old.txt"  1>nul 2>nul
::    ren "__readme_aria2c.txt" "__readme_aria2c.old.txt"  1>nul 2>nul
::    "aria2c.exe" "--version"     1>"__readme_aria2c.txt" 2>&1
::    "aria2c.exe" "--help=#all"  1>>"__readme_aria2c.txt" 2>&1
::    popd
::  ) 
::


  if exist ".\AtomicParsley\AtomicParsley.exe" ( 
      echo [INFO] found "AtomicParsley.exe", skipping download. 1>&2
  ) else (  
    mkdir "AtomicParsley" 1>nul 2>nul
    pushd "AtomicParsley"
    call :CURL_OVER_TOR "https://github.com/wez/atomicparsley/releases/latest/download/AtomicParsleyWindows.zip" "AtomicParsleyWindows.zip"
    move "AtomicParsleyWindows.zip" "%TEMP%"
    pushd "%TEMP%"
    "7za.exe" e -y "AtomicParsleyWindows.zip"
    popd
    move "%TEMP%\AtomicParsley.exe" ".\"
    del /f /q "__readme_atomicparsley.old.txt"  1>nul 2>nul
    ren "__readme_atomicparsley.txt" "__readme_atomicparsley.old.txt"  1>nul 2>nul
    "AtomicParsley.exe" --help  1>"__readme_atomicparsley.txt" 2>&1
    popd
  ) 



  if exist ".\ffmpeg\ffmpeg.exe" ( 
    if exist ".\ffmpeg\ffprobe.exe" ( 
      echo [INFO] found "ffmpeg.exe" and "ffprobe.exe"
      goto FOUND_FFMPEG_AND_FFPROBE
    ) 
  ) 
  mkdir "ffmpeg" 1>nul 2>nul
  pushd "ffmpeg"
  ::note: alternative "https://github.com/yt-dlp/FFmpeg-Builds/releases/latest/download/ffmpeg-master-latest-win64-gpl.zip"
  call :CURL_OVER_TOR "https://github.com/nanake/ffmpeg-tinderbox/releases/latest/download/ffmpeg-win64-nonfree.tar.zst" "ffmpeg-win64-nonfree.tar.zst"
  move "ffmpeg-win64-nonfree.tar.zst" "%TEMP%"
  pushd "%TEMP%"
  "7za.exe" e -y "ffmpeg-win64-nonfree.tar.zst"
  "7za.exe" e -y "ffmpeg-win64-nonfree.tar"
  popd
  move "%TEMP%\ffmpeg.exe" ".\"
  move "%TEMP%\ffprobe.exe" ".\"
  del /f /q "__readme_ffmpeg.old.txt"  1>nul 2>nul
  ren "__readme_ffmpeg.txt" "__readme_ffmpeg.old.txt"  1>nul 2>nul
  "ffmpeg.exe"  --help full   1>"__readme_ffmpeg.txt" 2>&1
  del /f /q "__readme_ffprobe.old.txt"  1>nul 2>nul
  ren "__readme_ffprobe.txt" "__readme_ffprobe.old.txt"  1>nul 2>nul
  "ffprobe.exe" --help full   1>"__readme_ffprobe.txt" 2>&1
  popd
  :FOUND_FFMPEG_AND_FFPROBE


  ::-----------------------------------------

  mkdir "yt-dlp" 1>nul 2>nul
  pushd "yt-dlp"

  ::--- yt-dlp.exe downloading without using the built-in updater, and without using api.github.com .
  set "YT_DLP_VERSION_LATEST="
  for /F "usebackq delims=" %%E IN (`call "curl.exe" --disable --silent --head --ipv4 --proxy "socks5h://127.0.0.1:9150" --max-redirs 1 --location --output nul --write-out "%%{url_effective}" --url "https://github.com/yt-dlp/yt-dlp-nightly-builds/releases/latest/download/yt-dlp.exe" 2^>nul`) do (
    set "YT_DLP_VERSION_LATEST=%%E"
    goto EXIT_LOOP_YT_DLP_VERSION_LATEST
  )
  :EXIT_LOOP_YT_DLP_VERSION_LATEST
  
  echo.%YT_DLP_VERSION_LATEST% 1>latest_url.txt

  set "YT_DLP_VERSION_LATEST=%YT_DLP_VERSION_LATEST:~66,17%"
  echo.%YT_DLP_VERSION_LATEST% 1>latest_version.txt


  set "YT_DLP_VERSION_CURRENT="
  for /F "usebackq delims=" %%E IN (`call "yt-dlp.exe" --version 2^>nul`) do (
    set "YT_DLP_VERSION_CURRENT=%%E"
    goto EXIT_LOOP_YT_DLP_VERSION_CURRENT
  )
  :EXIT_LOOP_YT_DLP_VERSION_CURRENT

  echo [INFO] yt-dlp - current %YT_DLP_VERSION_CURRENT% - latest %YT_DLP_VERSION_LATEST% 1>&2

  if ["%YT_DLP_VERSION_LATEST%"] equ ["%YT_DLP_VERSION_CURRENT%"] (
    goto YT_DLP_WAS_ALREADY_UPDATED
  )

  ::--- note: the whole two checks above is just to "delete" (well.. rename) any existing version. which will trigger the download. readme are --help entries. it's a good way to figure out if anything important has changed from one version to another.
  del /f /q "yt-dlp.exe.old"         1>nul 2>nul
  ren "yt-dlp.exe" "yt-dlp.exe.old"  1>nul 2>nul
  call :CURL_OVER_TOR "https://github.com/yt-dlp/yt-dlp-nightly-builds/releases/latest/download/yt-dlp.exe" "yt-dlp.exe"

  del "__readme_yt-dlp.old.txt"                        1>nul 2>nul
  ren "__readme_yt-dlp.txt" "__readme_yt-dlp.old.txt"  1>nul 2>nul
  "yt-dlp.exe" --version   1>"__readme_yt-dlp.txt" 2>&1
  "yt-dlp.exe" --help     1>>"__readme_yt-dlp.txt" 2>&1
  :YT_DLP_WAS_ALREADY_UPDATED
  )
  popd

endlocal

pause



::------------------------------------------------------
:: downloads dependencies
:: updates yt-dlp without using the built-in updater
:: nor api.github.com
::------------------------------------------------------

::------------------------------------------------------------------------------------------------------------------------
:: the script tries to reach a few minimum requirements of a reasonably recent tools.
::
:: curl.exe 
::   tries to get a recent verion of curl first with C:\Windows\System32\curl.exe (supports proxy), or powershell downloader (no proxy)
::   modified version of "https://curl.se/windows/latest.cgi?p=win64-mingw.zip"
::   https://gist.github.com/eladkarako/0aad76e9bcf42908e0e2a09895f8691c#file-readme-md
::
:: 7za.exe
::   for unpacking zips, a modified version of a recent build from https://github.com/mcmilk/7-Zip-zstd
::   https://gist.github.com/eladkarako/0aad76e9bcf42908e0e2a09895f8691c#file-readme-md
::
:: node.exe
::   the url is a recent build. used in yt-dlp.
::
:: ffmpeg.exe and ffprobe.exe
::   master tool for working with media files. decent version from the maintainers of yt-dlp.
::   the build isn't as great as https://github.com/repos/nanake/ffmpeg-tinderbox
::   but this release has "same name convention", direct download URL, nanake/ffmpeg-tinderbox needs api.github.com (rate limit) and JSON parsing.
::
:: AtomicParsley.exe
::   yt-dlp prefer it over ffmpeg.exe for some reason for setting meta-tags and embedding thumbnails.
::
:: tee.exe,unix2dos.exe
::   part of unix tools (git for windows x64). used to write to screen and to file same time. 
::
:: notes:
::  - the curl downloading part, uses proxy, which will fail if non is opened.
::  - there is expert pack of tor.exe https://www.torproject.org/download/tor/
::    https://archive.torproject.org/tor-package-archive/torbrowser/15.0.10/tor-expert-bundle-windows-x86_64-15.0.10.tar.gz
::  - the curl part checks, if was given a second argument to the procedure (filename), and then checks if the filename exists, and skips the download if it is.
::  - if you want to force download, delete the files.
::  - I know curl has '--skip-existing' which works well if the downloaded file does not need unpacking for example 'yt-dlp.exe', but since I am also downloading archives, it is better to manage the "check if file exists" manually. it makes the curl part more generic. 
::  - yt-dlp checking if update is needed:
::    - yt-dlp parses api.github.com, which often fails.
::    - yt-dlp github releases uses "same name convention" for artifacts.
::    - yt-dlp nightly github releases tags, uses same versioning scheme as the yt-dlp.exe --version
::    - by query the most recent URL and the version from current yt-dlp.exe, it is possible to figure out if there is a need to update.
::    - the latest URL (or version) is now available from the redirect HEAD request, but the plain releases/latest url is cleaner.
::
::https://gist.github.com/eladkarako/0aad76e9bcf42908e0e2a09895f8691c#file-essentials-7zip-with-additional-codecs-curl-aria2c-md
::------------------------------------------------------------------------------------------------------------------------
