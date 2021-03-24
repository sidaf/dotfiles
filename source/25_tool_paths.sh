path_prepend "$HOME/bin"
path_prepend "$HOME/.local/bin"
path_append "$HOME/Tools/Scripts"
path_append "$HOME/Scripts"
path_append "$HOME/.scripts"
path_append "$HOME/Tools/Burp"
path_append "$HOME/Tools/PyCharm/bin"
path_append "$HOME/Tools/PhpStorm/bin"
path_append "$HOME/Tools/RubyMine/bin"
path_append "$HOME/Tools/WebStorm/bin"
path_append "/opt/nessus/bin/"
path_append "/opt/nessus/sbin/"

#if [ -d "$HOME/Tools/Oracle/instantclient_12_1" ] ; then
#  ORACLE_HOME="$HOME/Tools/Oracle/instantclient_12_1"
#  path_append "$ORACLE_HOME"
#  export ORACLE_HOME=$ORACLE_HOME
#  export SQLPATH=$ORACLE_HOME
#  export TNS_ADMIN=$ORACLE_HOME
#  if is_linux ; then
#    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ORACLE_HOME
#  fi
#  if is_osx ; then
#    export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$ORACLE_HOME
#    # On macOS 10.11+, using the DYLD_LIBRARY_PATH is not possible unless System Integrity Protection (SIP) is disabled, so lets export OCI_DIR instead
#    export OCI_DIR=$ORACLE_HOME
#  fi
#fi
