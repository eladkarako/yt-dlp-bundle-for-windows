<h3><code>yt-dlp</code> bundle</h3>

- pre-set configuration and notes. audio, video daily, audio-based low res video.
- own dependency downloader, and yt-dlp nightly updater that does not uses <code>api.github.com</code>.
- portable, self-contained.
- uses TOR browser, and `SOCKS5h` proxy by default (you should keep it opened in the background).
- tweak, scriptable. developer friendly.

<hr/>

1. download and unpack https://github.com/eladkarako/yt-dlp-bundle-for-windows/archive/refs/heads/master.zip  
2. (download and) open TOR browser and let it connect   https://www.torproject.org/dist/torbrowser/15.0.16/tor-browser-windows-x86_64-portable-15.0.16.exe  
3. run `__update_dependencies.cmd` it will download dependencies for `yt-dlp` including `yt-dlp.exe` nightly.
4. use `__yt-dlp.cmd` as your main "entry point" to use `yt-dlp`. you can optionally add the bundle folder to your system's `PATH` and you'll be able to call `__yt-dlp.cmd` from anywhere. to download to the current folder.  

<hr/>

5. there are `__logs` and `__temp_cache` folder under the bundle folder.  
6. you can edit `__yt_dlp__export_youtube_cookies.cmd`, `BROWSER_PROFILE_PATH` to point to your favorite browser. then you can edit `__yt-dlp.cmd` uncommenting `::set  ARGS=%ARGS% --cookies "%FOLDER_OWN%\__cookies_youtube.txt"` to include those cookies in your `yt-dlp` run.  
7. you can use `__yt_dlp__list.cmd` with first parameter pointing to a text-based file filled with links to download, or use `__yt_dlp__list_local.cmd` and put links you want to download in `__yt_dlp__list_local.txt` .
8. make sure to not share the logs or cookies file as they might include private information. when opening a bug for `yt-dlp` you need to redact the log file, and pre-remove `--print-traffic` from configuration file as it includes video ids as well as cookies information. other than that there is a local history file named `__yt_dlp__archive_history.txt` stored in the bundle folder, that helps to avoid re-downloading videos.

<hr/>

all this bundle does is provide some use cases to help you use `yt-dlp`,  
with some examples, notes and scripts.  

I hope it will be helpful for you :)  

<hr/>

feel free to open up an issue with  
https://github.com/eladkarako/yt-dlp-bundle-for-windows/issues/new  
if you have any question.

<a href="https://paypal.me/31adkarak0" target="_blank" rel="noopener noreferrer"><img src="https://img.shields.io/badge/Sponsor-Donate-blue?logo=paypal&style=flat" alt="PayPal Donation"><br/><img src="https://www.paypalobjects.com/webstatic/mktg/Logo/pp-logo-100px.png" alt="PayPal Donation"></a>

