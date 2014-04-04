#!/bin/bash

# Functions
function format_time () {
    num=$1
    min=0
    hour=0
    day=0
    if((num>59));then
        ((sec=num%60))
        ((num=num/60))
        if((num>59));then
            ((min=num%60))
            ((num=num/60))
            if((num>23));then
                ((hour=num%24))
                ((day=num/24))
            else
                ((hour=num))
            fi
        else
            ((min=num))
        fi
    else
        ((sec=num))
    fi
    formattedTime="$hour hours $min mins $sec secs"
}

function get_time_since_start () {
    END=$(date +%s)
    DIFF=$(( $END - $START ))
    format_time $DIFF
}

function get_time_since_last_event () {
    if [[ -z "$LAST" ]] ; then
        LAST=$START
    fi
    END=$(date +%s)
    DIFF=$(( $END - $LAST ))
    format_time $DIFF
    LAST=$END
}


#script
START=$(date +%s)
echo "---- Starting ----"
# set some useful variables.
appPath="/usr/local/bin"
applicationSupportDir=$HOME"/Library/Application Support/krep"
# outputPath=`dirname "$1"`/krep-converted 
outputPath="$HOME/Desktop/krep-converted"
extractedAudioPath="$applicationSupportDir/extract"
normalizedAudioPath="$applicationSupportDir/normalize"
compressedVideoPath="$applicationSupportDir/video"
internalPath=`pwd`/Krep.app/Contents/Resources

# Check everything we need installed actuallyis.
echo "---- checking for brew ----"
which -s brew
if [[ $? = 0 ]] ; then
    #brew is intalled -  lets go...

    # Create output folder
    if [ ! -d "$outputPath" ] ; then
      mkdir -p "$outputPath"
    fi

    # Create temp audio folders
    if [ ! -d "$extractedAudioPath" ] ; then
      mkdir -p "$extractedAudioPath"
    fi

    if [ ! -d "$normalizedAudioPath" ] ; then
      mkdir -p "$normalizedAudioPath"
    fi

    if [ ! -d "$compressedVideoPath" ] ; then
      mkdir -p "$compressedVideoPath"
    fi

    echo ""
    echo "-------------------------------------------  ---- checking for sox ----"
    which -s sox || /usr/local/bin/brew install sox

    echo ""
    echo "-------------------------------------------  ---- checking for ffmpeg ----"
    which -s ffmpeg || /usr/local/bin/brew install ffmpeg

    echo ""
    echo "-------------------------------------------  ---- checking for HandBrakeCLI ----"
    which -s HandBrakeCLI || /usr/local/bin/brew install https://raw.github.com/sceaga/homebrew-tap/master/handbrakecli.rb


    echo
    echo ""
    echo "-------------------------------------------  ---- $# files dropped ----"
 

    # loop through the dropped files
    # have to use this method rather than $@ as we're within Platypus.
    while test $# -gt 0
    do
        file="$1"
        shift
 
        echo ""
        echo "-------------------------------------------"
        echo "---- processing a dropped file : $file ----"
        echo
    
        fileName=`basename "$file"`
        fileAndPathNoExt="${file%.*}"
        fileNameNoExt="${fileName%.*}"
        fileExtension="${file##*.}"
    
        #make extention lowercase so it's easier to test.
        fileExtension=`echo $fileExtension | tr '[:upper:]' '[:lower:]'`

        extractedSubs=$extractedAudioPath/$fileNameNoExt.srt
        
        extractedAudio=$extractedAudioPath/$fileNameNoExt.wav
        normalizeAudio=$normalizedAudioPath/$fileNameNoExt.wav
        compressedVideo=$compressedVideoPath/$fileNameNoExt.m4v

        aacAudio=$extractedAudioPath/$fileNameNoExt.m4a


        if [ $fileExtension == "avi" ]; then
            echo "---- Starting compression ----"
            echo $appPath/HandBrakeCLI -i "$file" -o "$compressedVideo" --preset="AppleTV 3" -v
            $appPath/HandBrakeCLI -i "$file" -o "$compressedVideo" --preset="AppleTV 3" -v
            # $internalPath/HandBrakeCLI -i "$file" -o "$compressedVideo" --preset="AppleTV 3" -v
            file="$compressedVideo"   
        fi

        echo ""
        echo "-------------------------------------------  ---- Starting audio extraction ----"
        echo $appPath/ffmpeg -i "$file" -vn -y "$extractedAudio"
        $appPath/ffmpeg -i "$file" -vn -y "$extractedAudio"

        echo ""
        echo "-------------------------------------------  ---- Starting volume increase  ----"
        echo $appPath/sox "$extractedAudio" "$normalizeAudio" vol `$appPath/sox "$extractedAudio" -n stat -v 2>&1`
        $appPath/sox "$extractedAudio" "$normalizeAudio" vol `$appPath/sox "$extractedAudio" -n stat -v 2>&1`

        echo ""
        echo "-------------------------------------------  ---- Creating AAC Audio  ----"
        echo $appPath/ffmpeg -i "$normalizeAudio" -acodec libfaac -b:a 256k -y "$aacAudio"
        $appPath/ffmpeg -i "$normalizeAudio" -acodec libfaac -b:a 256k -y "$aacAudio"

        echo ""
        echo "-------------------------------------------  ---- Starting Subtitle extraction ----"
        echo $appPath/ffmpeg -i "$file" -vn -an -codec:s:0 srt -y "$extractedSubs"
         
        if $appPath/ffmpeg -i "$file" -vn -an -codec:s:0 srt -y "$extractedSubs" ; then
            echo "-------------------------------------------Subtitles present-------------------------------------------"
            SUBS=1
        else
            echo "---------------------------------------------No Subtitles----------------------------------------------"
            SUBS=0
        fi

        if [ $SUBS -eq 1 ] ; then
            #there are subtitles present in the orginal file and they have been successfully extracted
            echo ""
            echo "-------------------------------------------  ---- Starting video creation ----"
            echo $appPath/ffmpeg -i  "$file" -i "$aacAudio" -acodec copy -vcodec copy -y "$compressedVideo"
            $appPath/ffmpeg -i  "$file" -i "$aacAudio" -acodec copy -vcodec copy -y "$compressedVideo"
                   
            
            echo ""
            echo "-------------------------------------------  ---- Adding in subtitles ----"
            echo $appPath/ffmpeg -i  "$compressedVideo" -i "$extractedSubs" -acodec copy -vcodec copy -y -scodec mov_text -y "$outputPath/$fileNameNoExt.m4v"
            $appPath/ffmpeg -i  "$compressedVideo" -i "$extractedSubs" -acodec copy -vcodec copy -scodec mov_text -y "$outputPath/$fileNameNoExt.m4v"

        else 
            #no subtitles in the orginal file so this would be a good place to look for an external file.
            echo ""
            echo "-------------------------------------------  ---- Starting video creation ----"
            echo $appPath/ffmpeg -i  "$file" -i "$aacAudio" -acodec copy -vcodec copy -y "$compressedVideo"
            $appPath/ffmpeg -i  "$file" -i "$aacAudio" -acodec copy -vcodec copy -y "$outputPath/$fileNameNoExt.m4v"

        fi

       
        echo ""
        echo "-------------------------------------------  ---- Cleaning up ----"
        rm -rf "$extractedAudio"
        rm -rf "$normalizeAudio"
        rm -rf "$compressedVideo"
        get_time_since_last_event
        echo ""
        echo "-------------------------------------------  ---- finished processing this file ----"
        echo ""
        echo "-------------------------------------------  ---- and it took $formattedTime ----"
        echo 
   done
else
    echo "This app relies on Homebrew being installed"
    echo Open a terminal and type : 
    echo /usr/bin/ruby -e \"\$\(curl\ \-fsSL\ https\:\/\/raw\.github\.com\/Homebrew\/homebrew\/go\/install\)\"
fi

get_time_since_start
echo 
echo "All done it took $formattedTime"