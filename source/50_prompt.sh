# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

if [ "$color_prompt" = yes ]; then
  # override default virtualenv indicator in prompt
  VIRTUAL_ENV_DISABLE_PROMPT=1

  prompt_status() { local e=$?; [ $e != 0 ] && echo -e "$e "; }
  prompt_symbol() {
    if [ "$EUID" -eq 0 ]; then
      printf "%s" "#";
    else
      printf "%s" "\$"
    fi
  }
  prompt_at=@
  normal_color='\[\033[0m\]'
  normal_bold_color='\[\033[0;1m\]'
  prompt_status_color='\e[38;5;202m\]'
  #prompt_color='\[\033[;32m\]'
  prompt_color='\[\e[0;38;5;245m\]'
  #info_color='\[\e[1;38;5;245m\]'
  info_color='\[\033[1;32m\]'
  if [ "$EUID" -eq 0 ]; then
    # Change prompt colors for root user
    #prompt_color='\[\033[;94m\]'
    prompt_color='\[\e[38;5;245m\]'
    info_color='\[\033[1;31m\]'
  fi
  PS1=$prompt_color'┌─${debian_chroot:+($debian_chroot)─}${VIRTUAL_ENV:+('$normal_bold_color'$(basename $VIRTUAL_ENV)'$prompt_color')}['$info_color'\u${prompt_at}\h'$prompt_color':'$normal_bold_color'\w'$prompt_color']\n'$prompt_color'└'$info_color'$(prompt_symbol)'$normal_color' '
  #PS1=$prompt_color'┌─${debian_chroot:+($debian_chroot)─}${VIRTUAL_ENV:+('$normal_bold_color'$(basename $VIRTUAL_ENV)'$prompt_color')}['$info_color'\u${prompt_at}\h'$prompt_color':'$normal_bold_color'\w'$prompt_color']\n'$prompt_color'└'$prompt_status_color'$(prompt_status)'$info_color'$(prompt_symbol)'$normal_color' '
  #PS1='${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV)) }${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac
