"use strict";

/*  run with 
 *  node.exe tee.js my_log.log "%SystemRoot%\System32\cmd.exe" /C "my_cmd.bat" %*
 *  the sub_process ("child") will remain until you will exit from it.
 *  all signals (ctrl+c, etc..) will transform from this runner to the program.
 *  error and exit messages are written to both this runner stderr (as information) and the log file.
 *  https://github.com/eladkarako/yt-dlp-bundle-for-windows/raw/refs/heads/dependencies/js/tee.js
 */


queueMicrotask(()=>{
const EOL            = require("os").EOL
     ,fs             = require("fs")
     ,fs_promises    = require("fs/promises")
     ,child_process  = require("child_process")
     ,options        = {stdio                    : ["inherit", "pipe", "pipe"]
                       ,encoding                 : "utf8"
                       ,detached                 : false
                       ,shell                    : false
                       ,windowsVerbatimArguments : false
                       ,flush                    : true
                       }
     ,path           = require("path")
     ,args           = process.argv.slice(2)
     ,log_file       = args[0]
     ,program        = args[1]
     ,program_args   = args.slice(2)
     ,log_stream     = fs.createWriteStream(log_file, {encoding:"utf8", flush:true, flags:"a"})
     ;

const sub_process   = child_process.spawn(program, program_args, options);
sub_process.stdout.pipe(process.stdout, { end: false });
sub_process.stderr.pipe(process.stderr, { end: false });
sub_process.stdout.pipe(log_stream,     { end: false });
sub_process.stderr.pipe(log_stream,     { end: false });

let is_sigint_forwarded = false;

process.on("SIGINT", () => {
  if (sub_process.exitCode !== null || sub_process.killed){ return; } // child already done
  if(false === is_sigint_forwarded){
    is_sigint_forwarded = true;
    queueMicrotask(()=>{
      try { sub_process.kill("SIGINT"); } catch (e) {}
      /*
      setTimeout(() => {  //force kill
        if (!sub_process.killed && sub_process.exitCode === null) {
          try { sub_process.kill(); } catch (e) {}
        }
      }, 1500);
      */
    });
  }
});
    
["SIGTERM","SIGHUP"].forEach(sig => {
  process.on(sig,()=>{
    queueMicrotask(()=>{
      try { sub_process.kill(sig); } catch (e) {}
    });
  });
});

sub_process.on("error", (err) => {
  const msg = "Failed to start: " + err.message + EOL;
  process.stderr.write(msg);
  log_stream.write(msg);

  log_stream.end(()=>{
    queueMicrotask(()=>{
      process.exit(1)
    });
  });
});

sub_process.on("close", (code, signal)=>{
  const SIGNALS = {SIGHUP:   1
                  ,SIGINT:   2
                  ,SIGQUIT:  3
                  ,SIGILL:   4
                  ,SIGTRAP:  5
                  ,SIGABRT:  6
                  ,SIGBUS:   7
                  ,SIGFPE:   8
                  ,SIGKILL:  9
                  ,SIGUSR1: 10
                  ,SIGSEGV: 11
                  ,SIGUSR2: 12
                  ,SIGPIPE: 13
                  ,SIGALRM: 14
                  ,SIGTERM: 15
                  }
       ,exit_code = ("number" === typeof code) ? code : ("string" === typeof signal ? 128 + (SIGNALS[signal] || 0) : 1)
       ;

  const msg = EOL + "[sub_process exited with code=" + code + " signal=" + signal + "]" + EOL;
  process.stderr.write(msg);
  log_stream.write(msg);

  log_stream.end(()=>{
    queueMicrotask(()=>{
      process.exit(exit_code)
    })
  });

}); //sub_process on close



});//micro task



void 0;