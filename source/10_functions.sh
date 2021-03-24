path_append() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    export PATH="${PATH:+"$PATH:"}$1"
  fi
}

path_prepend() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    export PATH="$1${PATH:+":$PATH"}"
  fi
}

keepalive() {
  if [ "$#" -ne 1 ]; then
    echo "ERROR: expecting the host to ping as an argument!"
    return 1
  fi
  echo -e "\e[37;42mPing started on `date`\e[m"
  while ping -c1 "$1" &>/dev/null; do sleep 60 ; done; echo -e "\e[37;41mPing failed on `date`\e[m"
}
