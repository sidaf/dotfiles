# Kali-only stuff. Abort if not Ubuntu.
is_kali || return 1

#echo '[*] Adding Sidaf PPA repository'

#cat > /etc/apt/sources.list.d/sidaf-ppa.list << "EOF"
#deb https://ppa.sidaf.net kali-rolling main non-free contrib
#deb-src https://ppa.sidaf.net kali-rolling main non-free contrib
#EOF
#wget -q -O - https://ppa.sidaf.net/archive-key.asc | apt-key add -

#echo '[*] Updating system'
#
#apt -qq update
#apt -y -qq dist-upgrade
#apt -y -qq autoremove

echo '[*] Installing standard packages'
#apt -y -qq install meta-sidaf
#apt -y -qq install rsh-client
#apt -y -qq install oracle-java8-jdk
#update-java-alternatives -s oracle-java8-jdk-amd64 &> /dev/null

echo '[*] Cloning Scripts repository from github'
git -q clone https://github.com/sidaf/scripts $HOME/Scripts

echo '[*] Cloning Metasploit Scripts repository from github'
git -q clone --recurse-submodules http://github.com/sidaf/metasploit-scripts $HOME/.msf4

echo '[*] Cloning Recon-ng Scripts repository from github'
git -q clone https://github.com/sidaf/recon-ng-scripts $HOME/.recon-ng

#echo '[*] Downloading SNMP MIBS'
#sed -i -e 's/^mibs :/#mibs :/' /etc/snmp/snmp.conf
#apt -y -qq install snmp-mibs-downloader
#download-mibs &>/dev/null

#echo '[*] Setup windows-exploit-suggester'
#cd $HOME/Downloads && windows-exploit-suggester -u &>/dev/null && cd $HOME

#if dpkg-query -W -f='${Status}' gnome-shell | grep "ok installed"; then
#  # Proceed only if gnome is installed
#
#  echo '[*] Enabling GDM automatic login'
#  file=/etc/gdm3/daemon.conf; [ -e "${file}" ] && cp -n $file{,.bkup}
#  sed -i 's/^.*AutomaticLoginEnable = .*/AutomaticLoginEnable = true/' "${file}"
#  sed -i 's/^.*AutomaticLogin = .*/AutomaticLogin = root/' "${file}"
#
#  echo '[*] Disabling screensaver'
#  gsettings set org.gnome.desktop.session idle-delay 0
#  gsettings set org.gnome.desktop.screensaver lock-enabled false
#  gsettings set org.gnome.desktop.screensaver idle-activation-enabled false
#
#  echo '[*] Disabling automatic sleep'
#  gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
#  gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'
#
#  echo '[*] Disabling recent files'
#  gsettings set org.gnome.desktop.privacy remember-recent-files false
#
#  echo '[*] Enabling date in top bar'
#  gsettings set org.gnome.desktop.interface clock-show-date true
#
#  # Hide window minimize button
#  gsettings set org.gnome.desktop.wm.preferences button-layout "appmenu:maximize,close"
#
#  echo '[*] Disabling extensions'
#  gnome-shell-extension-tool -d apps-menu@gnome-shell-extensions.gcampax.github.com
#  gnome-shell-extension-tool -d places-menu@gnome-shell-extensions.gcampax.github.com
#  gnome-shell-extension-tool -d EasyScreenCast@iacopodeenosee.gmail.com
#fi
