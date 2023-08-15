[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh

preexec() {
  if [ "UNSET" == "${timer}" ]; then
    timer=$SECONDS
  else
    timer=${timer:-$SECONDS}
  fi
}

precmd() {
  if [ "UNSET" == "${timer}" ]; then
    timer_show="0s"
  else
    the_seconds=$((SECONDS - timer))
    # use format-duration to make time more human readable
    timer_show="$(format-duration seconds $the_seconds)"
  fi
  timer="UNSET"
}
