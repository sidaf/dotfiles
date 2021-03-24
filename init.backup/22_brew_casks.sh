# Exit if Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && e_error "Brew casks need Homebrew/Linuxbrew installed." && return 1

# Ensure the cask keg and recipe are installed.
kegs=(caskroom/cask)
brew_tap_kegs

# Common casks
casks=(
  firefox
  google-chrome
  java
  vlc
)
brew_install_casks

echo ""
echo "Install workstation related casks?  (y/n)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  casks=(
    1password
    citrix-receiver
    dbeaver-enterprise
    dropbox
    evernote
    firefox
    google-chrome
    java
    jetbrains-toolbox
    paragon-extfs
    paragon-ntfs
    teamviewer
    virtualbox
    viscosity
    vlc
    vmware-fusion
    vmware-horizon-client
    vmware-remote-console
    yed
  )
  brew_install_casks
fi
