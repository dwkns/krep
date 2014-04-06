krep
====

Drag and drop application to process `.mkv` and `.mp4` files to be iTunes friendly.

[Platapus](http://sveinbjorn.org/platypus) is used to provide drag and drop functionailty to a shell script.

The shell script `krep.sh` leverages [Sox](http://sox.sourceforge.net), [FFmpeg](http://ffmpeg.org) and [HandBrakeCLI](http://handbrake.fr/downloads2.php) which do all the hard work.

The audio is extracted, normalised and then the volume increased to it's maximum without distorting. 

Subtitles are preserved if they exist in the orginal file.

`.avi` files are detected and recompressed using the AppleTV 3 HandBrake profile. 

