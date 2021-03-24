# Linux-only stuff. Abort if not Linux.
is_linux || return 1

# Make 'less' more.
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Aliases
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

alias rdp="rdesktop -k en-gb -g 1024x768 -5 -x l"
alias rdp_s="rdesktop -k en-gb -g 800x600 -5 -x l"
alias xrdp="xfreerdp /size:1024x768 /kbd:0x00000809 +clipboard +fonts /drive:stuff,."
alias xrdp_s="xfreerdp /size:800x600 /kbd:0x00000809 +clipboard +fonts /drive:stuff,."


# Ubuntu-only stuff.
if is_ubuntu; then
  # Package management
  alias upgrade="sudo apt update && sudo apt dist-upgrade"
  alias install="sudo apt install"
  alias remove="sudo apt remove --purge"
  alias search="apt-cache search"
fi

# Arch-only stuff.
if is_arch; then
  if [ "$DESKTOP_SESSION" = "gnome" ];then
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/keyring/ssh"
  fi
fi

if is_ubuntu || is_kali; then
  DEBEMAIL="sion.dafydd@gmail.com"
  DEBFULLNAME="Sion Dafydd"
  export DEBEMAIL DEBFULLNAME
fi
