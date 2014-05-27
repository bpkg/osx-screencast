#!/bin/bash

## main
osx_screenshot_dependencies () {
  declare -a local features=( ffmpeg convert )
  for ((i = 0; i < ${#features[@]}; ++i)); do
    local f="${features[$i]}"
    if ! type "${f}"  > /dev/null 2>&1; then
      echo >&2 "error: Missing \`${f}' dependency"
      return 1
    fi
  done
  return 0
}

## export
if [[ ${BASH_SOURCE[0]} != $0 ]]; then
  export -f osx_screenshot_dependencies
fi
