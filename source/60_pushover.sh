function pushover {
  if [ $# -eq 0 ]; then
	  echo "Usage: pushover <message> [title]"
	  return 1
  fi

  if [[ -z "${PUSHOVER_APP_TOKEN}" || -z "${PUSHOVER_USER_KEY}" ]]; then
    echo "Unable to send pushover message, PUSHOVER_APP_TOKEN and PUSHOVER_USER_KEY variables are not set!"
    return 1
  fi

  MESSAGE=$1
  TITLE=$2

  if [ $# -lt 2 ]; then
	  TITLE="`whoami`@${HOSTNAME}"
  fi

  if [[ "$(type -P curl)" ]]; then
    curl -s \
      -F "token=${PUSHOVER_APP_TOKEN}" \
      -F "user=${PUSHOVER_USER_KEY}" \
      -F "title=${TITLE}" \
      -F "message=${MESSAGE}" \
      https://api.pushover.net/1/messages.json \
      > /dev/null 2>&1
  elif [[ "$(type -P wget)" ]]; then
    wget -qO- \
      https://api.pushover.net/1/messages.json \
      --post-data="token=${PUSHOVER_APP_TOKEN}&user=${PUSHOVER_USER_KEY}&message=${MESSAGE}&title=${TITLE}" \
      > /dev/null 2>&1
  else
    echo "Unable to send pushover message, curl or wget are not installed!"
    return 1
  fi
}
