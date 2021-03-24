# Kali-only stuff. Abort if not Kali.
is_kali || return 1

# install packages
function apt_install_packages() {
  packages=($(setdiff "${packages[*]}" "$(dpkg --get-selections | grep -v deinstall | awk '{print $1}')"))
  if (( ${#packages[@]} > 0 )); then
    echo "[*] Installing packages: ${packages[*]}"
    for package in "${packages[@]}"; do
      sudo LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get -y -qq install "$package"
    done
  fi
}

packages=(
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

apt_install_packages

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
