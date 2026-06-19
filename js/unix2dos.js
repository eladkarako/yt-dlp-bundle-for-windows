"use strict";

/* - removes BOM (from anywhere in the file, to counter a file that was a result of concat. of few files).
 * - removes terminal-colors, CSI sequences (ESC [ ... letter), OSC sequences (ESC ] ... BEL or ESC \), single-shift/SS3 (ESC O ...), plus other common control sequences.
 * - removes \0 i.e. NULL character from anywhere in the file.
 * - remove "\r", and normalize EOL to Windows EOL "\r\n".
 * - tries to preserve (restore) original times.
 * https://github.com/eladkarako/yt-dlp-bundle-for-windows/raw/refs/heads/dependencies/js/unix2dos.js
 */

const fs_promises    = require("fs/promises")
     ,max_timeout    = 20 * 1000    //limit read/write time to 20 seconds max.
     ,regex_bom      = /\uFEFF/gmu
     ,regex_control  = /\x1B(?:\[[@-~]*[ -/]*[@-~]|\][^\x07]*(?:\x07|\x1B\\)|O[@-~]|\([0-9A-Za-z]|\)[0-9A-Za-z]|=|>)/gmu
     ,regex_null     = /\0/gmu
     ,regex_line_r   = /\r/gmu
     ,regex_line_n   = /\n/gmu
     ,args           = process.argv.slice(2)
     ,input_file     = args[0] || ""
     ;

if("" === input_file){
  throw new Error("[ERROR] you must specify at least one file.");
}

const output_file    = args[1] || input_file;

queueMicrotask(async ()=>{
  const stats = await fs_promises.stat(input_file,{bigint:false,throwIfNoEntry:true});

  let content = await fs_promises.readFile(input_file, {"encoding":"utf8", "signal":AbortSignal.timeout(max_timeout)});

  content = content.replace(regex_bom, "")
                   .replace(regex_control, "")
                   .replace(regex_null, "")
                   .replace(regex_line_r, "").replace(regex_line_n,"\r\n")
                   ;

  await fs_promises.writeFile(output_file, content, {"encoding":"utf8", "signal":AbortSignal.timeout(max_timeout)});

  await fs_promises.utimes(output_file, stats.atime, stats.mtime);

  process.exit(0);
});


void 0;