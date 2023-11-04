#!/bin/bash
#: Title       : rndpswd
#: Version     : 1.0
#: Description : generate a random password
#: Options
# Users can set a password length -l
# Users can add a special character -s
# Users can set vrbose mode with -v

#######################################
# Print a Usage message.
# Arguments:
#   None
# Outputs:
#   Write a help message
#######################################
usage() {
  echo "Usage: ${0} [-vs] [-l LENGTH]" >&2
  echo 'Generate a random password.'
  echo ' -l LENGTH specify the password length.'
  echo ' -s Append a special character to the password.'
  echo ' -v display output in verbose mode'
  exit 1
}

#######################################
# log additional messages
# locals:
#   MESSAGE
# Arguments:
#   message to log
# Outputs:
#   log message passed as argument
#######################################
log() {
  local MESSAGE="${@}"
  if [[ "${VERBOSE}" = 'true' ]]; then
    echo "${MESSAGE}"
  fi
}
# set a default password length
LENGTH=48

while getopts :vl:s OPTION; do
  case ${OPTION} in
    v)
      VERBOSE='true'
      log 'Verbose mode on.'
      ;;
    l)
      LENGTH="${OPTARG}"
      ;;
    s)
      USE_SPECIAL_CHARACTER='true'
      ;;
    ?)
      usage
      ;;
  esac
done

log 'Generating a password'
PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c${LENGTH})

#Append a special character
if [[ "${USE_SPECIAL_CHARACTER}" = 'true' ]]; then
  log 'Selecting a random special character.'
  SPECIAL_CHARACTER=$(echo '!@#$%^&*()-=+' | fold -w1 | shuf | head -c1)
  PASSWORD="${PASSWORD}${SPECIAL_CHARACTER}"
fi

log 'Done'

log 'Here is your password'
#display password
echo "${PASSWORD}"


exit 0
