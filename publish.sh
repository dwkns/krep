#!/bin/bash
# defaults read /Applications/Krep.app/Contents/Info.plist 
# defaults write /Applications/Krep.app/Contents/Info.plist  CFBundleShortVersionString 1.3

gitCommitMessage=`git log -1 --pretty=%B`
echo $gitCommitMessage

DIR="$( cd "$( dirname "$0" )" && pwd )"
echo $DIR


CFBundleShortVersionString=`defaults read $DIR/Krep.app/Contents/Info.plist CFBundleShortVersionString`
CFBundleVersion=`defaults read $DIR//Krep.app/Contents/Info.plist CFBundleVersion`

echo $CFBundleShortVersionString

newCFBundleShortVersionString=`echo $CFBundleShortVersionString + 0.01 | bc`
newCFBundleVersion=`echo $CFBundleVersion + 0.01 | bc`


defaults write $DIR/Krep.app/Contents/Info.plist CFBundleShortVersionString $newCFBundleShortVersionString
defaults write $DIR/Krep.app/Contents/Info.plist CFBundleVersion $newCFBundleVersion

CFBundleShortVersionString=`defaults read $DIR/Krep.app/Contents/Info.plist CFBundleShortVersionString`
echo $CFBundleShortVersionString

git add -A
git commit -m "$gitCommitMessage (publish)"
git push --all



# alias gc='git commit'
# alias ga='git add -A'
# alias gs='git status'
# alias gb='git branch'
# alias gp='git push --all'
# alias gco='git checkout'

# num=$(($num1 + $num2))
# echo $num

# echo CFBundleVersion
# git log -1 --pretty=%B