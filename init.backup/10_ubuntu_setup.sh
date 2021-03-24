# Ubuntu-only stuff. Abort if not Ubuntu.
is_ubuntu || return 1

# If the old files isn't removed, the duplicate APT alias will break sudo!
sudoers_old="/etc/sudoers.d/sudoers-sion"; [[ -e "$sudoers_old" ]] && sudo rm "$sudoers_old"

# Installing this sudoers file makes life easier.
sudoers_file="sudoers-dotfiles"
sudoers_src=$DOTFILES/conf/ubuntu/$sudoers_file
sudoers_dest="/etc/sudoers.d/$sudoers_file"
if [[ ! -e "$sudoers_dest" || "$sudoers_dest" -ot "$sudoers_src" ]]; then
  cat <<EOF
The sudoers file can be updated to allow "sudo apt-get" and "sudo apt" to be
executed without asking for a password. You can verify that this worked
correctly by running "sudo -k apt-get". If it doesn't ask for a password, and
the output looks normal, it worked.

THIS SHOULD ONLY BE ATTEMPTED IF YOU ARE LOGGED IN AS ROOT IN ANOTHER SHELL.

This will be skipped if "Y" isn't pressed within the next $prompt_delay seconds.
EOF
  read -N 1 -t $prompt_delay -p "Update sudoers file? [y/N] " update_sudoers; echo
  if [[ "$update_sudoers" =~ [Yy] ]]; then
    e_info "Updating sudoers"
    visudo -cf "$sudoers_src" &&
    sudo cp "$sudoers_src" "$sudoers_dest" &&
    sudo chmod 0440 "$sudoers_dest" &&
    echo "File $sudoers_dest updated." ||
    echo "Error updating $sudoers_dest file."
  else
    echo "Skipping."
  fi
fi

# Update APT.
e_info "Updating APT"
sudo apt -qq update
sudo apt -y -qq dist-upgrade

# Function used in subsequent init scripts.

# Apt install packages
function apt_install_packages() {
  packages=($(setdiff "${packages[*]}" "$(dpkg --get-selections | grep -v deinstall | awk '{print $1}')"))
  if (( ${#packages[@]} > 0 )); then
    e_info "Installing APT packages: ${packages[*]}"
    for package in "${packages[@]}"; do
      sudo apt -y -qq install "$package"
    done
  fi
}

# Install APT packages.
packages=(
  bridge-utils
  build-essential
  curl
  deborphan
  dkms
  dos2unix
  finger
  git
  ipcalc
  ldap-utils
  macchanger
  ntpdate
  openvpn
  p7zip-full
  p7zip-rar
  pwgen
  rsh-client
  rwho
  screen
  snmp
  smbclient
  traceroute
  tshark
  unrar
  upx-ucl
  vim
  vim-nox
  vlan
  whois
)

apt_install_packages

echo ""
echo "Would you like to install packages dependant on X11?  (y/n)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  packages=(
    freerdp-x11
    rdesktop
    wireshark
    x11-apps
    xtightvncviewer
    xsel
  )

  apt_install_packages
fi
