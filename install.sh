# set up some colours
note () {
  echo -e "\n\033[0;94m====> $1 \033[0m"
}

msg () {
  echo -e "\n\033[0;32m==============> $1 \033[0m"
}
warn () {
  echo -e "\n\033[0;31m====> $1 \033[0m"
}

msg "Installing Krep"

ps cax | grep Krep > /dev/null # Is Krep running?

if [ $? -eq 0 ]; then # yep, killing it
  warn "Krep is running. Killing it"
  killall -9 Krep
fi

if [  -d "/Applications/Krep.app" ]; then # is Krep installed
  warn "Krep is installed, skipping"
else
  mkdir -p /tmp/krep
  curl -L https://github.com/dwkns/krep/archive/master.zip -o  "/tmp/krep/Krep.zip"

  unzip -o -q "/tmp/krep/Krep.zip" -d "/tmp/krep"
  cp -rf "/tmp/krep/krep-master/Krep.app" "/Applications"
  rm -rf "/tmp/krep/krep-master"
  rm -rf "/tmp/krep/Downloads/Krep.zip"

  # dockutil --add "/Applications/Krep.app" --no-restart

fi

note "done"
