#!/bin/bash

## outputs usage
osx_screenshot_export_usage () {
  echo "usage: osx-screenshot-export [-h]"
  echo "   or: osx-screenshot-export [-f fps] [-s scale] [-d delay] <src> <dest>"
  echo
  echo "options:"
  echo "   -f,--fps        Frames per second (Default: 10)"
  echo "   -s,--scale      Output scaling (Default: 320:-1)"
  echo "   -d,--delay      Frame delay"
  echo "   -h,--help       Show this message"
  return 0
}

## main
osx_screenshot_export () {
  local arg="${1}"
  local scale="320:-1"
  local fps="10"
  local delay="5"
  local src=""
  local dest=""
  local tmpdir=${TMPDIR:-/tmp}
  local tmp=""
  local fcmd=""

  ## enure dependencies exist or bail
  osx_screenshot_dependencies || return $?

  ## parse opts
  for arg in "${@}"; do
    case "${arg}" in
      -h|--help)
        osx_screenshot_export_usage
        return 0
        ;;

      -s|--scale| \
      -d|--delay| \
      -f|--fps)   \
        shift
        if [ -z "${1:0:1}" ]; then
          echo >&2 "error: Missing value of \`${arg}'"
        elif [ "-" = "${1:0:1}" ]; then
          echo >&2 "error: Invalid option \`${1}'"
        else
          case "${arg}" in
            -s|--scale) scale="${1}" ;;
            -d|--delay) delay="${1}" ;;
            -f|--fps) fps="${1}" ;;
          esac
          shift
          continue
        fi
        osx_screenshot_export_usage
        return 1
        ;;

      *)
        if [ "-" = "${arg:0:1}" ]; then
          continue
        fi

        if [ -z "${src}" ]; then
          src="${1}"
          shift
        elif [ -z "${dest}" ]; then
          dest="${1}"
          shift
        fi
        ;;

    esac
  done

  ## ensure source
  if [ -z "${src}" ]; then
    echo >&2 "error: Missing source file"
    osx_screenshot_export_usage
    return 1
  fi

  ## ensure destination
  if [ -z "${dest}" ]; then
    echo >&2 "error: Missing destination file"
    osx_screenshot_export_usage
    return 1
  fi

  ## tmp frame dir
  tmp="${tmpdir}/frames-${src}-${dest}"

  ## purge
  rm -rf "${tmp}"

  ## create
  mkdir -p "${tmp}"

  ## create frames with ffmpeg
  echo >&2 "Transcoding frames..."
  (
    ffmpeg -i "${src}" -vf scale=${scale} -r ${fps} "${tmp}"/f%03d.png > /dev/null 2>&1
  )

  if (( $? > 0 )); then
    echo >&2 "error: An error occured during frame transcoding"
    return $?
  fi

  ## convert and write to desired file
  echo >&2 "Converting and writing to destination..."
  (
    convert -delay ${delay} -loop 0 "${tmp}"/f*.png "${dest}" > /dev/null 2>&1
  )

  if (( $? > 0 )); then
    echo >&2 "error: An error occured during transcoding convert (${src} => ${dest})"
    return $?
  fi

  printf >&2 'Ok! (%s => %s)\n' "${src}" "${dest}"
  return 0
}

## export
if [[ ${BASH_SOURCE[0]} != $0 ]]; then
  export -f osx_screenshot_export
fi

