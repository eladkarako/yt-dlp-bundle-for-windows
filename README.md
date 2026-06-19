these are few scripts I wrote that are hosted here for convenient (copied from my github's gists)

- `js/timestamp.js` - getting timestamp.  
- `js/unix2dos.js` - normalizing EOL.  
- `js/tee.js` - run another program and arguments, mirroring stdout and stderr to log file.  

<hr/>

I know hosting binaries isn't a good practice. but those tools are too good and normally distributes within installer/archive.  

- `curl.exe` - to download stuff (although most Windows 10+ will include `C:\Windows\System32\curl.exe`).  
- `7za.exe` - 7zip (with extra codecs) to unpack stuff from command-line.  

<hr/>

with those I can query (from cmd or nodejs)  
URLs to get a direct download URLs,  
unpack archives and fix EOL for Windows.  

<hr/>

those could be added next  

- https://download.sysinternals.com/files/Streams.zip - removing NTFS extra unsafe zone data stream.  

- https://download.sysinternals.com/files/Sync.zip - flush to disk before moving file.  

- https://www.nirsoft.net/utils/nircmd-x64.zip - for risky delete actions - use the the recycle-bin. https://www.nirsoft.net/utils/nircmd2.html#moverecyclebin  
for killing process from specific path, allowing other copies from other paths to keep running - https://www.nirsoft.net/utils/nircmd2.html#killprocess  
for copying files via explorer with progress - https://www.nirsoft.net/utils/nircmd2.html#shellcopy  



