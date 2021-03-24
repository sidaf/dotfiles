if is_linux ; then
  BREW_HOME="$HOME/Tools/Brew"
  if [ -f "$BREW_HOME/bin/brew" ] ; then
    path_prepend "$BREW_HOME/share/python"
    path_prepend "$BREW_HOME/sbin"
    path_prepend "$BREW_HOME/bin"
    export MANPATH="$BREW_HOME/share/man:$MANPATH"
    export INFOPATH="$BREW_HOME/share/info:$INFOPATH"
    #export PYTHONPATH="$PYTHONPATH:$BREW_HOME/lib/python2.7/site-packages"
    export XDG_DATA_DIRS="$BREW_HOME/share:$XDG_DATA_DIRS"
    export HOMEBREW_NO_ANALYTICS=1
  fi
elif is_osx ; then
  BREW_HOME="/usr/local"
  if [ -d "$BREW_HOME/Cellar" ] ; then
    #export PYTHONPATH="$PYTHONPATH:$BREW_HOME/lib/python2.7/site-packages"
    export HOMEBREW_NO_ANALYTICS=1
  fi
fi

if [[ "$(type -P brew)" ]]; then
  alias start.postgresql="pg_ctl -D $(brew --prefix)/var/postgres -l $(brew --prefix)/var/postgres/server.log start"
  alias stop.postgresql="pg_ctl -D $(brew --prefix)/var/postgres stop -s -m fast"
fi
