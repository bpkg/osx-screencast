#!/bin/bash

## outputs usage
osx_screenshot_record_usage () {
  echo "usage: osx-screenshot-record [-h]"
  echo "   or: osx-screenshot-record [-a application]"
  echo
  echo "options:"
  echo "   -a,--application     Set screen recording application  (Default: 'Quicktime Player')"
  echo "   -h,--help            Show this message"
  return 0
}

## main
osx_screenshot_record () {
  local arg="${1}"
  local app="Quicktime Player"

  ## parse opts
  for arg in "${@}"; do
    shift
    case "${arg}" in
      -h|--help)
        osx_screenshot_record_usage
        return 0
        ;;

      -a|--application)
        if [ -z "${1:0:1}" ]; then
          echo >&2 "error: Missing value of \`${arg}'"
        elif [ "-" = "${1:0:1}" ]; then
          echo >&2 "error: Invalid option \`${1}'"
        else
          app="${1}"
          continue
        fi
        osx_screenshot_record_usage
        return 1
        ;;
    esac
  done

  ## feed info to user
  {
    echo "Opening \`${app}'.."

    shopt -s nocasematch
    if [[ "quicktime" =~ "${app}" ]]; then
      echo
      echo "If you're using 'Quicktime Player' then follow these steps:"
      echo "  * Go to File -> New Screen Recording"
      echo "  * Select screen portion by dragging a rectangle"
      echo "  * Press the record button"
      echo "  * Go to File -> Export -> As Movie"
      echo "  * Saved the video in full quality with a filename"
      echo
    fi
    shopt -u nocasematch

    open -a "${app}"
    if (( $? > 0 )); then
      echo >&2 "error: An error occurred attempting to open \`${app}'"
      return $? || 1
    fi
  } >&2
  return 0
}

## export
if [[ ${BASH_SOURCE[0]} != $0 ]]; then
  export -f osx_screenshot_record
fi
