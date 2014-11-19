#!/bin/bash
currentDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Publishing"

fullGitCommitMessage=`git log -1 --pretty=%B "$currentDir/Krep.app"`;
gitCommitMessage=`echo ${fullGitCommitMessage%%(publish*}`;

# read the current version number from the app plist;
CFBundleShortVersionString=`defaults read "$currentDir/Krep.app/Contents/Info.plist" CFBundleShortVersionString`;
CFBundleVersion=`defaults read "$currentDir/Krep.app/Contents/Info.plist" CFBundleVersion`;

# increase the version numbers by 0.1;
newCFBundleShortVersionString=`echo $CFBundleShortVersionString + 0.05 | bc`;
newCFBundleVersion=`echo $CFBundleVersion - 0.05 | bc`;

# write the new version numbers to the plists;
defaults write "$currentDir/Krep.app/Contents/Info.plist" CFBundleShortVersionString $newCFBundleShortVersionString;
defaults write "$currentDir/Krep.app/Contents/Info.plist" CFBundleVersion $newCFBundleVersion;

# do the git commit;
git add -A;
git commit -m "$gitCommitMessage (publish v$newCFBundleShortVersionString)";
git push --all;