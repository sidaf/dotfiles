if [[ ! "$(type -P docker)" ]]; then
  return 1
fi

function docker_shell() {

  if [[ $# -eq 0 || "$*" == "--help" || "$*" == "-h" ]]; then
    echo "Usage: docker_shell [options] <image> [command]"
    return 1
  fi

  VOLUMES=""
  PRIVILEGED=""
  ARGS="--interactive --tty"

  if [[ -z "${VBASH}" ]] || [[ "${VBASH}" -eq 1 ]]; then
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

  if [[ "${HERE}" -eq 1 ]]; then
    DIRNAME=${PWD##*/}
    VOLUMES+="--volume ${PWD}:/${DIRNAME} --workdir /${DIRNAME}"
  fi

  if [[ "${PRIV}" -eq 1 ]]; then
    PRIVILEGED="--privileged"
  fi

  if [[ "${DETACH}" -eq 1 ]]; then
    ARGS="--detach"
  fi

  docker run ${ARGS} --rm ${PRIVILEGED} ${VOLUMES} "$@"
}

function docker_shell_here() {

  if [[ $# -eq 0 || "$*" == "--help" || "$*" == "-h" ]]; then
    echo "Usage: docker_shell_here [options] <image> [command]"
    return 1
  fi

  HERE=1 docker_shell "$@"
}

function docker_inject_gateway() {
  CONTAINER=$1
  ROUTER=$2

  if [[ $# -ne 2 || "$*" == "--help" || "$*" == "-h" ]]; then
    echo "Usage: docker_inject_gateway <container> <router_container>"
    return 1
  fi

  BLUE="\e[34m"
  RED="\e[31m"
  BOLD="\e[1m"
  NORMAL="\e[0m"

  if [[ "${CONTAINER}" == "${ROUTER}" ]]; then
    echo -e "${RED}[-]${NORMAL} Umm, a container can't route traffic through itself..."
    return 1
  fi

  ROUTE=$(docker inspect --format '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${ROUTER})
  if [[ ! $? -eq 0 ]]; then
    echo -e "${RED}[-]${NORMAL} Could not retrieve the IP address for container ${ROUTER}"
    return 1
  fi
  ROUTE=${ROUTE//[$'\t\r\n ']}


  echo -ne "${BLUE}[>]${NORMAL} Routing traffic from ${BOLD}${CONTAINER}${NORMAL} through ${BOLD}${ROUTER}${NORMAL} (${BOLD}${ROUTE}${NORMAL}) ... "

  docker exec --privileged -t -i ${CONTAINER} sh -c "ip route del default" && \
    docker exec --privileged -t -i ${CONTAINER} sh -c "ip route add default via ${ROUTE}" && \
    docker exec --privileged -t -i ${CONTAINER} sh -c "echo 'nameserver ${ROUTE}' > /etc/resolv.conf"

  if [[ $? -eq 0 ]]; then
    echo "done"
  else
    echo -e "\n${RED}[-]${NORMAL} Uh-oh, something went wrong :-("
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
complete -F _docker_shell_here_completions docker_shell_here
complete -F _docker_inject_gateway_completions docker_inject_gateway
