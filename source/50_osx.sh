# OSX-only stuff. Abort if not OSX.
is_osx || return 1

# APPLE, Y U PUT /usr/bin B4 /usr/local/bin?!
PATH="/usr/local/bin:$(path_remove /usr/local/bin)"
export PATH

# Xquartz
path_append "/usr/X11/bin"

# Trim new lines and copy to clipboard
alias c="tr -d '\n' | pbcopy"

# Make 'less' more.
[[ "$(type -P lesspipe.sh)" ]] && eval "$(lesspipe.sh)"

# Start ScreenSaver. This will lock the screen if locking is enabled.
alias ss="open /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app"

# Enable Bash completion if available
if [[ "$(type -P brew)" ]]; then
  HOMEBREW_PREFIX="$(brew --prefix)"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
      [[ -r "$COMPLETION" ]] && source "$COMPLETION"
    done
  fi
fi

if [ -d "$HOME/.bash_completion.d" ]; then
  for COMPLETION in "$HOME/.bash_completion.d/"* ; do
    [[ -r "$COMPLETION" ]] && source "$COMPLETION"
  done
fi

# Allow vmrun to be accessed easily if available
if [ -f /Applications/VMware\ Fusion.app/Contents/Library/vmrun ]; then
  alias vmrun="/Applications/VMware\ Fusion.app/Contents/Library/vmrun"
fi
