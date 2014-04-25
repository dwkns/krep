#!/bin/bash

############################## Functions ##############################
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

function doPrintLine () {    
            stringLength=${#1} 
            totalLength=$2
            symbolLength=$((($totalLength-$stringLength)/2))
            symbolString=""
            for i in $(seq 1 $symbolLength) 
                do symbolString+="-"
            done
            outputString="$symbolString $1 $symbolString"
            echo
            echo $outputString
}

function printLineShort () {
    doPrintLine "$1" 50 
}

function printLine () {
    doPrintLine "$1" 100 
}

function processFile () {
        file="$1"
        

        printLine "processing a new file"
        echo "$file"
    
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
            printLine "Starting compression"
            echo $appPath/HandBrakeCLI -i "$file" -o "$compressedVideo" --preset="AppleTV 3" -v
            echo
            $appPath/HandBrakeCLI -i "$file" -o "$compressedVideo" --preset="AppleTV 3" -v
            # $internalPath/HandBrakeCLI -i "$file" -o "$compressedVideo" --preset="AppleTV 3" -v
            file="$compressedVideo"   
        fi

        
        printLine "Starting audio extraction"
        echo $appPath/ffmpeg -i "$file" -vn -y "$extractedAudio"
        $appPath/ffmpeg -i "$file" -vn -y "$extractedAudio"

        
        printLine "Starting volume increase"
        echo $appPath/sox "$extractedAudio" "$normalizeAudio" vol `$appPath/sox "$extractedAudio" -n stat -v 2>&1`
        echo
        $appPath/sox "$extractedAudio" "$normalizeAudio" vol `$appPath/sox "$extractedAudio" -n stat -v 2>&1`

        
        # printLine "Creating AAC Audio "
        # echo $appPath/ffmpeg -i "$normalizeAudio" -acodec libfaac -b:a 256k -y "$aacAudio"
        # $appPath/ffmpeg -i "$normalizeAudio" -acodec libfaac -b:a 256k -y "$aacAudio"


        printLine "Starting Subtitle extraction"
        echo $appPath/ffmpeg -i "$file" -vn -an -codec:s:0 srt -y "$extractedSubs"
        echo
        if $appPath/ffmpeg -i "$file" -vn -an -codec:s:0 srt -y "$extractedSubs" ; then
            printLineShort "Subtitles present"
            SUBS=1
        else
            printLineShort "No Subtitles found"
            SUBS=0
        fi

            
         printLine "Starting video creation"


        if [ $SUBS -eq 1 ] ; then
            #there are subtitles present in the orginal file and they have been successfully extracted
            
           
        echo $appPath/ffmpeg -i  "$file" -i "$normalizeAudio" -vcodec copy -acodec libfaac -b:a 256k  -y "$compressedVideo"
        echo
        $appPath/ffmpeg -probesize 100000000 -analyzeduration 100000000 -i  "$file" -i "$normalizeAudio" -vcodec copy -acodec libfaac -b:a 256k  -y "$compressedVideo"

        printLineShort "Adding in subtitles"
        echo $appPath/ffmpeg -i  "$compressedVideo" -i "$extractedSubs" -acodec copy -vcodec copy -y -scodec mov_text -y "$outputPath/$fileNameNoExt.m4v"
        echo
        $appPath/ffmpeg -i  "$compressedVideo" -i "$extractedSubs" -acodec copy -vcodec copy -scodec mov_text -y "$outputPath/$fileNameNoExt.m4v"
        
        else

        echo $appPath/ffmpeg -i  "$file" -i "$normalizeAudio" -vcodec copy -acodec libfaac -b:a 256k  -y "$outputPath/$fileNameNoExt.m4v"
        echo
        $appPath/ffmpeg -probesize 100000000 -analyzeduration 100000000 -i  "$file" -i "$normalizeAudio" -vcodec copy -acodec libfaac -b:a 256k  -y "$outputPath/$fileNameNoExt.m4v"
        
        fi

       
        
        printLineShort "Cleaning up after this file"
        # rm -rf "$extractedAudio"
        # rm -rf "$normalizeAudio"
        # rm -rf "$compressedVideo"
        get_time_since_last_event
        
        printLineShort "finished processing this file"
        
        printLineShort "and it took $formattedTime"
}

############################## script ##############################
START=$(date +%s)
printLine "Starting"
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
printLine "checking everything is installed"
echo "checking for Homebrew"
which -s brew
if [[ $? = 0 ]] ; then
    echo  ">> Homebrew is installed"
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

    
    echo "checking for sox"
    which -s sox || /usr/local/bin/brew install sox 
    which -s sox && echo ">> Sox is installed"

    
    echo "checking for ffmpeg"
    which -s ffmpeg || /usr/local/bin/brew install ffmpeg
    which -s ffmpeg && echo ">> ffmpeg is installed"
    
    echo "checking for HandBrakeCLI"
    which -s HandBrakeCLI || /usr/local/bin/brew install https://raw.github.com/sceaga/homebrew-tap/master/handbrakecli.rb
    which -s HandBrakeCLI && echo ">> HandBrakeCLI is installed"

    printLine "Processing files"
    
    echo "$# items dropped"
 

    #build an array of files to process from the ones that were dropped.
    fileArray=()

    while test $# -gt 0
    # loop through the dropped files
    do
        PASSED="$1"
        if [[ -d $PASSED ]]; then
            # If it's a directory
            
            echo "--- DIR ---  $PASSED is a directory"
            # do a find for all the given file types, this is recurrsive 
            # so will look in all sub directories.
            # Add them to the fileArray.
            
            IFS=$'\n' #make it ignore the spaces in the filenames.
            tempArray=( "$(find $1 -iname '*.m4v' -o -iname '*.mp4' -o -iname '*.mkv') -o -iname '*.avi')")
            for file in ${tempArray[@]} ; do
                fileArray=("${fileArray[@]}" "$file")
            done
            
        elif [[ -f $PASSED ]]; then

            echo "--- FILE --- $PASSED is a file"
            # add the file to the array.
            fileArray=("${fileArray[@]}" "$1")
        else
            echo "$PASSED is not valid"
            exit 1
        fi
        shift  
    done
    echo
    echo "${#fileArray[@]} files to process"
    for i in "${fileArray[@]}"; do
        echo "$i"
    done
    for i in "${fileArray[@]}"; do
        processFile "$i"
    done

    
else
    echo "#!#!##!#!##!#!##!#!##!#!##!#!# This app relies on Homebrew being installed #!#!##!#!##!#!##!#!##!#!##!#!#"
    echo Open a terminal and type : 
    echo /usr/bin/ruby -e \"\$\(curl\ \-fsSL\ https\:\/\/raw\.github\.com\/Homebrew\/homebrew\/go\/install\)\"
fi

get_time_since_start
printLine "All done it took $formattedTime"