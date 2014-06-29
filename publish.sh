#!/bin/bash

# Auto incriments the version number of Krep and then uploads it to git.
# get the last git commit message
fullGitCommitMessage=`git log -1 --pretty=%B`;

echo $fullGitCommitMessage
gitCommitMessage=`echo ${fullGitCommitMessage%%(publish*}` # Result: aaa
echo $gitCommitMessage

# # get the directory that this script is running from.
# DIR="$( cd "$( dirname "$0" )" && pwd )";


# # read the current version number from the app plist
# CFBundleShortVersionString=`defaults read $DIR/Krep.app/Contents/Info.plist CFBundleShortVersionString`;
# CFBundleVersion=`defaults read $DIR//Krep.app/Contents/Info.plist CFBundleVersion`;

# # increase the version numbers by 0.1
# newCFBundleShortVersionString=`echo $CFBundleShortVersionString + 0.01 | bc`;
# newCFBundleVersion=`echo $CFBundleVersion + 0.01 | bc`;

# # write the new version numbers to the plists
# defaults write $DIR/Krep.app/Contents/Info.plist CFBundleShortVersionString $newCFBundleShortVersionString;
# defaults write $DIR/Krep.app/Contents/Info.plist CFBundleVersion $newCFBundleVersion;


# do the git commit
# git add -A;
# git commit -m \"$gitCommitMessage (publish)\";
# git push --all;