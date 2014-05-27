#!/bin/bash

source `which ${BASH_SOURCE[0]}-dependencies`
source `which ${BASH_SOURCE[0]}-record`
source `which ${BASH_SOURCE[0]}-export`

## outputs usage
osx_screenshot_usage () {
  echo "usage: osx-screenshot [-hV]"
  echo "   or: osx-screenshot record [-h] [-a application]"
  echo "   or: osx-screenshot export [-h] [-f fps] [-s scale] [-d delay] <src> <dest>"
  return 0
}

## outputs version
osx_screenshot_version () {
  echo "0.0.1"
}

## main
osx_screenshot () {
  local cmd=""
  local arg="${1}"

  ## enure dependencies exist or bail
  osx_screenshot_dependencies || return $?

  if [ -z "${arg}" ]; then
    osx_screenshot_usage
    return 1
  fi

  ## parse opts
  case "${arg}" in
    -h|--help)
      osx_screenshot_usage
      return 0
      ;;

    -V|--version)
      osx_screenshot_version
      return 0
      ;;

    *)
      ## dynamically create command from originating
      ## script caller
      cmd="osx_screenshot_${arg}"
      shift
      if [ "-" = "${arg:0:1}" ]; then ## unknown flags
        echo >&2 "error: Unknown option \`${arg}'"
        osx_screenshot_usage
        return 1
      else ## proxy commands
        if type "${cmd}" > /dev/null 2>&1; then
          ( "${cmd}" "${@}" )
          return $?
        else
          echo >&2 "error: Unknown command \`${arg}'"
          osx_screenshot_usage
          return 1
        fi
      fi
      ;;
  esac

  return 0
}

## export
if [[ ${BASH_SOURCE[0]} != $0 ]]; then
  export -f osx_screenshot
else
  osx_screenshot "${@}"
  exit $?
fi
