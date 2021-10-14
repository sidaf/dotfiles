# Kali-only stuff. Abort if not Kali.
[[ "$(cat /etc/issue 2> /dev/null)" =~ Kali || "$(lsb_release -i 2> /dev/null)" =~ Kali ]] || return 1

apt_packages=(
python3
python3-dev
python3-pip
python3-aiodns
python3-aiohttp
python3-dnspython
python3-geoip2
python3-httplib2
python3-impacket
python3-iptools
python3-iptools
python3-ipwhois
python3-libnmap
python3-lxml
python3-netaddr
python3-openssl
python3-pycurl
python3-requests
python3-tabulate
python3-tqdm
)

pip_packages=(
)

function apt_install_packages() {
  installed_apt_packages="$(dpkg --get-selections | grep -v deinstall | awk 'BEGIN{FS="[\t:]"}{print $1}' | uniq)"
  packages=($(setdiff "${apt_packages[*]}" "$installed_apt_packages"))
  if (( ${#packages[@]} > 0 )); then
    for package in "${apt_packages[@]}"; do
      sudo LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get -y -qq install "$package"
    done
  fi
}

function pip_install_packages() {
  installed_pip_packages="$(pip list 2>/dev/null | awk '{print $1}')"
  pip_packages=($(setdiff "${pip_packages[*]}" "$installed_pip_packages"))

  if (( ${#pip_packages[@]} > 0 )); then
    for package in "${pip_packages[@]}"; do
      #pip install "$package"
      python3 -m pip install --user "$package"
    done
  fi
}

echo '[*] Installing apt packages'
apt_install_packages
echo '[*] Installing pip packages'
pip_install_packages

if [ -d "$HOME/.scripts/.git" ] ; then
  echo '[*] Updating scripts repository from github'
  git -C "$HOME/.scripts" pull
else
  echo '[*] Cloning scripts repository from github'
  git clone --quiet https://github.com/sidaf/scripts $HOME/.scripts
fi
