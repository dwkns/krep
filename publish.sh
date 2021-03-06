#!/bin/bash
currentDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "==> Publishing"

fullGitCommitMessage=`git log -1 --pretty=%B .`;
gitCommitMessage=`echo ${fullGitCommitMessage%%(publish*}`;

# read the current version number from the app plist;
CFBundleShortVersionString=`defaults read "$currentDir/Krep.app/Contents/Info.plist" CFBundleShortVersionString`;
currentVersion=`echo $CFBundleShortVersionString | bc`;
echo "==> Current version is : $currentVersion"
newBundleVersion=`echo $CFBundleShortVersionString + 0.01 | bc`;
echo "==> New verison will be : $newBundleVersion"
echo "==> Doing commit..."

# write the new version numbers to the plists;
defaults write "$currentDir/Krep.app/Contents/Info.plist" CFBundleShortVersionString $newBundleVersion;
defaults write "$currentDir/Krep.app/Contents/Info.plist" CFBundleVersion $newBundleVersion;

#check the versions
# CFBundleShortVersionString=`defaults read "$currentDir/Krep.app/Contents/Info.plist" CFBundleShortVersionString`;
# CFBundleVersion=`defaults read "$currentDir/Krep.app/Contents/Info.plist" CFBundleVersion`;
# echo "CFBundleShortVersionString is $CFBundleShortVersionString"
# echo "CFBundleVersion is $CFBundleVersion"


# do the git commit;
git add -A;

git commit -m "$gitCommitMessage (publish v$newBundleVersion)";
git tag -a $newBundleVersion -m "new version $newBundleVersion";
git push --tags; 
git push --all; 

echo "==> Done"

