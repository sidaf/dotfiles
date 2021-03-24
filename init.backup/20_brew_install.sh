if [[ ! "$(type -P brew)" ]]; then
  if is_ubuntu ; then
    e_info "Installing Linuxbrew dependancies"
    packages=(
      build-essential
      curl
      git
      libexpat1-dev
      libnetfilter-queue-dev
      libnfnetlink-dev
      libpcap-dev
      python-setuptools
      ruby
      ruby-bundler
      ruby-dev
    )
    apt_install_packages
    e_info "Installing Linuxbrew"
    mkdir -p $HOME/Tools/Brew
    true | git clone https://github.com/Linuxbrew/brew.git ~/Tools/Brew
  elif is_osx ; then
    e_info "Installing Homebrew"
    true | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
  source $DOTFILES/source/10_functions.sh
  source $DOTFILES/source/99_brew.sh
fi

# Exit if, for some reason, Brew is not installed.
[[ ! "$(type -P brew)" ]] && e_error "Homebrew failed to install." && return 1

e_info "Updating Homebrew"
brew doctor
brew update

# Functions used in subsequent init scripts.

# Tap Homebrew kegs.
function brew_tap_kegs() {
  kegs=($(setdiff "${kegs[*]}" "$(brew tap)"))
  if (( ${#kegs[@]} > 0 )); then
    e_info "Tapping Homebrew kegs: ${kegs[*]}"
    for keg in "${kegs[@]}"; do
      brew tap $keg
    done
  fi
}

# Tap Homebrew repo.
function brew_tap_repos() {
  kegs=($(setdiff "${repos[*]}" "$(brew tap)"))
  if (( ${#repos[@]} > 0 )); then
    e_info "Tapping Homebrew repos: ${repos[*]}"
    for repo in "${repos[@]}"; do
      brew tap $repo
    done
  fi
}

# Install Homebrew recipes.
function brew_install_recipes() {
  recipes=($(setdiff "${recipes[*]}" "$(brew list)"))
  if (( ${#recipes[@]} > 0 )); then
    e_info "Installing Homebrew recipes: ${recipes[*]}"
    for recipe in "${recipes[@]}"; do
      brew install $recipe
    done
  fi
}

# Install Homebrew casks.
function brew_install_casks() {
  casks=($(setdiff "${casks[*]}" "$(brew cask list 2>/dev/null)"))
  if (( ${#casks[@]} > 0 )); then
    e_info "Installing Homebrew casks: ${casks[*]}"
    for cask in "${casks[@]}"; do
      brew cask install $cask
    done
    brew cask cleanup
  fi
}
