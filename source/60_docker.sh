if [[ ! "$(type -P docker)" ]]; then
  return 1
fi

function docker_shell() {
  if [[ $# -eq 0 || "$*" == "--help" || "$*" == "-h" ]]; then
    echo "Usage: ${FUNCNAME[${#FUNCNAME[@]}-1]} [options] <image> [command]"
    return 127
  fi

  local VOLUMES
  local ARGS

  if [[ "${VBASH}" -eq 1 ]]; then
    BASH_PRIVATE=".bash_private"
    if [[ -f "${HOME}/${BASH_PRIVATE}" ]]; then
      VOLUMES+="--volume ${HOME}/${BASH_PRIVATE}:/root/${BASH_PRIVATE}:ro "
    fi
  fi

  if [[ "${VSSH}" -eq 1 ]]; then
    SSH_DIR=".ssh"
    if [[ -d "${HOME}/${SSH_DIR}" ]]; then
      VOLUMES+="--volume ${HOME}/${SSH_DIR}:/root/${SSH_DIR}:ro "
    fi
  fi

  if [[ "${VSCR}" -eq 1 ]]; then
    SCRIPTS_DIR=".scripts"
    if [[ -d "${HOME}/${SCRIPS_DIR}" ]]; then
      VOLUMES+="--volume ${HOME}/${SCRIPTS_DIR}:/root/${SCRIPTS_DIR} "
    fi
  fi

  if [[ "${HERE}" -eq 1 ]]; then
    HERE_PATH=$(printf %q "${PWD}")
    HERE_NAME=$(printf %q "${PWD##*/}")
    VOLUMES+="--volume ${HERE_PATH}:/${HERE_NAME} --workdir /${HERE_NAME} "
  fi

  VOLUMES="$(echo -e "${VOLUMES}" | sed -e 's/[[:space:]]*$//')"

  if [[ "${DETACH}" -eq 1 ]]; then
    ARGS="--detach"
  else
    ARGS="--interactive --tty"
  fi

  echo "-> docker run ${ARGS} --rm --privileged ${VOLUMES} $@"
  docker run ${ARGS} --rm --privileged ${VOLUMES} $@
}

function docker_shell_here() {
  HERE=1 VBASH=1 VSSH=1 VSCR=1 docker_shell "$@"
}

function docker_inject_gateway() {
  local CONTAINER=$1
  local ROUTER=$2

  if [[ $# -ne 2 || "$*" == "--help" || "$*" == "-h" ]]; then
    echo "Usage: docker_inject_gateway <container> <router_container>"
    return 127
  fi

  local BLUE="\e[34m"
  local RED="\e[31m"
  local GREEN="\e[32m"
  local BOLD="\e[1m"
  local NORMAL="\e[0m"

  if [[ "${CONTAINER}" == "${ROUTER}" ]]; then
    echo -e "${RED}[-]${NORMAL} Umm, a container can't route traffic through itself..."
    return 127
  fi

  local ROUTE=$(docker inspect --format '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${ROUTER})
  if [[ ! $? -eq 0 ]]; then
    echo -e "${RED}[-]${NORMAL} Uh-oh, could not retrieve the IP address for container ${ROUTER}"
    return 127
  fi
  ROUTE=${ROUTE//[$'\t\r\n ']}


  echo -ne "${BLUE}[>]${NORMAL} Attempting to set default gateway of ${BOLD}${CONTAINER}${NORMAL} to ${BOLD}${ROUTER}${NORMAL} (${BOLD}${ROUTE}${NORMAL}) ... "

  docker exec --privileged -t -i ${CONTAINER} sh -c "ip route del default" && \
    docker exec --privileged -t -i ${CONTAINER} sh -c "ip route add default via ${ROUTE}" && \
    docker exec --privileged -t -i ${CONTAINER} sh -c "echo 'nameserver ${ROUTE}' > /etc/resolv.conf"

  if [[ $? -eq 0 ]]; then
    echo -e "done"
  else
    echo -e "${RED}failed${NORMAL}"
  fi
}

_docker_shell_completions()
{
  local cur
  _get_comp_words_by_ref -n : cur

  COMPREPLY=($(compgen -W "$(docker images --format "{{.Repository}}:{{.Tag}}")" -- "${cur}"))

  __ltrim_colon_completions "${cur}"
}

_docker_inject_gateway_completions()
{
  COMPREPLY=($(compgen -W "$(docker ps --format "{{.Names}}")" -- "${COMP_WORDS[COMP_CWORD]}"))
}

complete -F _docker_shell_completions docker_shell
complete -F _docker_shell_completions docker_shell_here
complete -F _docker_inject_gateway_completions docker_inject_gateway
