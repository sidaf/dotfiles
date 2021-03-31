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
  ROUTE=$2

  if [[ $# -eq 0 || "$*" == "--help" || "$*" == "-h" ]]; then
    echo "Usage: docker_inject_gateway <container> [route|172.17.0.2]"
    return 1
  fi

  if [[ $# -lt 2 ]]; then
    ROUTE="172.17.0.2"
  fi

  docker exec --privileged -t -i ${CONTAINER} sh -c "ip route del default"
  docker exec --privileged -t -i ${CONTAINER} sh -c "ip route add default via ${ROUTE}"
  docker exec --privileged -t -i ${CONTAINER} sh -c "echo 'nameserver ${ROUTE}' > /etc/resolv.conf"
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
  if [ "${#COMP_WORDS[@]}" != "2" ]; then
    return
  fi

  COMPREPLY=($(compgen -W "$(docker ps --format "{{.Names}}")" -- "${COMP_WORDS[1]}"))
}

complete -F _docker_shell_completions docker_shell
complete -F _docker_shell_here_completions docker_shell_here
complete -F _docker_inject_gateway_completions docker_inject_gateway
