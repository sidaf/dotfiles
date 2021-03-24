if [[ "$(type -P docker)" ]]; then
  function docker_shell() {
    docker run --rm -it -v "${HOME}/.ssh":/root/.ssh -v "${HOME}/.bash_private":/root/.bash_private:ro "$@"
  }

  function docker_shell_here() {
    dirname=${PWD##*/}
    docker run --rm -it -v "${HOME}/.ssh":/root/.ssh -v "${HOME}/.bash_private":/root/.bash_private:ro -v "${PWD}":"/${dirname}" -w "/${dirname}" "$@"
  }
fi
