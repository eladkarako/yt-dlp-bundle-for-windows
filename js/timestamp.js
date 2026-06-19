"use strict";

/* outputs an 'ISO-like' timestamp, that is suitable for use as a filename - yyyymmddhhmmss - 20260619134901
 * https://github.com/eladkarako/yt-dlp-bundle-for-windows/raw/refs/heads/dependencies/js/timestamp.js
 */

queueMicrotask(()=>{
  const d         = new Date()
       ,timestamp = d.toISOString()
                     .replace(/[\-\:T]/ig,"")
                     .replace(/\..+$/g,"")
       ;

  console.log(timestamp);
  process.exit(0)
});//micro task


void 0;