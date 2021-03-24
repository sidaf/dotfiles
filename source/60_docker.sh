if [[ "$(type -P docker)" ]]; then
  function docker_shell() {
    BASH_PRIVATE=".bash_private"
    if [[ -f "${HOME}/${BASH_PRIVATE}" ]]; then
      VOLUMES="-v ${HOME}/${BASH_PRIVATE}:/root/${BASH_PRIVATE}:ro"
    fi

    SSH_DIR=".ssh"
    if [[ -d "${HOME}/${SSH_DIR}" ]]; then
      VOLUMES="${VOLUMES} -v ${HOME}/${SSH_DIR}:/root/${SSH_DIR}:ro"
    fi

    docker run --rm -it ${VOLUMES} "$@"
  }

  function docker_shell_here() {
    BASH_PRIVATE=".bash_private"
    if [[ -f "${HOME}/${BASH_PRIVATE}" ]]; then
      VOLUMES="-v ${HOME}/${BASH_PRIVATE}:/root/${BASH_PRIVATE}:ro"
    fi

    SSH_DIR=".ssh"
    if [[ -d "${HOME}/${SSH_DIR}" ]]; then
      VOLUMES="${VOLUMES} -v ${HOME}/${SSH_DIR}:/root/${SSH_DIR}:ro"
    fi

    DIRNAME=${PWD##*/}
    VOLUMES="${VOLUMES} -v ${PWD}:/${DIRNAME} -w /${DIRNAME}"

    docker run --rm -it ${VOLUMES} "$@"
  }
fi
