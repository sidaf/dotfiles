# Kali-only stuff. Abort if not Kali.
is_kali || return 1

apt_packages=(
apt-transport-https
at
bash-completion
bc
build-essential
ca-certificates
byobu
bzip2
cpio
curl
dc
default-jre-headless
dnsutils
dos2unix
dosfstools
ethtool
expect
file
fping
ftp
gdisk
git
golang
iputils-arping
iputils-ping
iputils-tracepath
jq
lftp
locales
macchanger
mlocate
nano
netcat-traditional
net-tools
perl
php-cli
p7zip-full
parted
python3
python3-dev
python3-pip
python3-venv
rsh-client
rsync
ruby
ruby-dev
socat
tcpdump
telnet
tftp
tmux
unar
unrar
unzip
upx-ucl
vlan
vim
wget
whois
xsltproc
zip
)

pip_packages=(
  pipx
)

function apt_install_packages() {
  installed_apt_packages="$(dpkg --get-selections | grep -v deinstall | awk 'BEGIN{FS="[\t:]"}{print $1}' | uniq)"
  packages=($(setdiff "${apt_packages[*]}" "$installed_apt_packages"))
  if (( ${#packages[@]} > 0 )); then
    e_header "Installing apt packages: ${apt_packages[*]}"
    for package in "${apt_packages[@]}"; do
      sudo LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get -y -qq install "$package"
    done
  fi
}

apt_install_packages

function pip_install_packages() {
  installed_pip_packages="$(pip list 2>/dev/null | awk '{print $1}')"
  pip_packages=($(setdiff "${pip_packages[*]}" "$installed_pip_packages"))

  if (( ${#pip_packages[@]} > 0 )); then
    e_header "Installing pip packages (${#pip_packages[@]})"
    for package in "${pip_packages[@]}"; do
      pip install "$package"
    done
  fi
}

pip_install_packages

if [ -d "$HOME/.scripts/.git" ] ; then
  echo '[*] Updating scripts repository from github'
  git -C "$HOME/.scripts" pull
else
  echo '[*] Cloning scripts repository from github'
  git clone --quiet https://github.com/sidaf/scripts $HOME/.scripts
fi

if [ -d "$HOME/.msf5/.git" ] ; then
  echo '[*] Updating metasploit scripts repository from github'
  git -C "$HOME/.msf5" pull
else
  echo '[*] Cloning metasploit scripts repository from github'
  git clone --quiet --recurse-submodules https://github.com/sidaf/metasploit-scripts $HOME/.msf5
fi

if [ -d "$HOME/.recon-ng/.git" ] ; then
  echo '[*] Updating recon-ng scripts repository from github'
  git -C "$HOME/.recon-ng" pull
else
  echo '[*] Cloning recon-ng scripts repository from github'
  git clone --quiet https://github.com/sidaf/recon-ng-scripts $HOME/.recon-ng
fi
