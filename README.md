#krep

Mac drag and drop application to process `.avi` , `.mkv` and `.mp4` files to be iTunes friendly and improve their audio.

[Platapus](http://sveinbjorn.org/platypus) is used to provide drag and drop functionality to a shell script.

The shell script in the app leverages [Sox](http://sox.sourceforge.net), [FFmpeg](http://ffmpeg.org) which do all the hard work.

The audio is normalised (companded to improved audibility in high noise environments) and then the volume increased to it's maximum non-clipping value. 

Will update itself when new version are available.

###Dependencies
Requires [Homebrew](http://brew.sh) which you can install with... 

````
$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
````

##Installation 
Run this from the command line on your local machine.

````
$ bash <(curl -s https://raw.githubusercontent.com/dwkns/krep/master/install.sh)
````
