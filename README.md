krep
====

Mac drag and drop application to process `.avi` , `.mkv` and `.mp4` files to be iTunes friendly and improve their audio.

[Platapus](http://sveinbjorn.org/platypus) is used to provide drag and drop functionality to a shell script.

The shell script compiled into the app leverages [Sox](http://sox.sourceforge.net), [FFmpeg](http://ffmpeg.org) which do all the hard work.

The audio is normalised (companded to improved audibility in high noise environments) and then the volume increased to it's maximum non-clipping value. 

Requires Homebrew to be installed. 

Will update itself when new version are available.
