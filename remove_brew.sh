#!/bin/bash
originalDir=`pwd`


dir=`brew --prefix`
if [ $? -eq 0 ]; then
    cd $dir
else
    cd /usr/local
fi


cd `brew --prefix`
rm -rf Cellar
brew prune
rm `git ls-files`
rm -r Library/Homebrew Library/Aliases Library/Formula Library/Contributions
rm -rf .git
rm -rf ~/Library/Caches/Homebrew
rm -rf ~/.homebrew
rm -rf ~/.rvm/bin/brew
cd $originalDir
echo "All done"