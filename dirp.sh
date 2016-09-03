#! /bin/bash
#
# # DIRectory series Permission checker (DIRP)
#
# Copyright 2016 Willem Oosting
#
# >This program is free software: you can redistribute it and/or modify
# >it under the terms of the GNU General Public License as published by
# >the Free Software Foundation, either version 3 of the License, or
# >(at your option) any later version.
# >
# >This program is distributed in the hope that it will be useful,
# >but WITHOUT ANY WARRANTY; without even the implied warranty of
# >MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# >GNU General Public License for more details.
# >
# >You should have received a copy of the GNU General Public License
# >along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# FORK ME AT GITHUB: https://github.com/woosting/dirp


# TO-DO:

#  function checkMount () {
#    if mount | grep /mnt/md0 > /dev/null; then
#      echo "yay"
#    else
#      echo "nay"
#    fi
#  }


# CONFIGURATION:

  EMCOL='\033[1m'    #EMPHASIS color (default: BOLD)
  NOKCOL='\033[0;31m' #NOT OK color (default: RED)
  OKCOL='\033[0;32m' #OK color (default: GREEN)
  RCOL='\033[0m'    #RESET color (default: terminal default)


# INITIALISATION:

  ERRORS=()

  while getopts r:w: option     #CL-INTAKE (flagged arguments)
  do
    case "${option}"
     in
      r) DIRS2READ+=(${OPTARG});;
      w) DIRS2WRITE+=(${OPTARG});;
    esac
  done

  if [ ${#DIRS2READ[@]} -gt 0 ]; then
    DIRS2CHECK[0]=${DIRS2READ[@]}
  fi

  if [ ${#DIRS2WRITE[@]} -gt 0 ]; then
    DIRS2CHECK[1]=${DIRS2WRITE[@]}
  fi

  if [ ${#DIRS2CHECK[@]} -eq 0 ]; then
    echo -e "USAGE: dirp [-r /path] [-w /path]"
    exit 1;
  fi


# FUNCTION DEFINITION:

  function reportOK() {
    echo -e "${OKCOL}[\u2713]$RCOL ${1}"
  }

  function reportNOK() {
    ERRORS+=("${1} verified NOK: ${2}")
    echo -e "${NOKCOL}[!]$RCOL ${1} ${2}"
  }

  function checkDir() {
    if [ ! -d "$2" ]; then
      reportNOK $2 "(not a directory)"
    else
      case ${1} in
        read)
          if [ -r "${2}" ]; then
            if [ ! "$(ls -A $2)"  ]; then
              reportNOK $2 "(empty)"
            else
              reportOK ${2}
            fi
          else
            reportNOK ${2}
          fi
        ;;
        write)
          if [ -w "${2}" ]; then
            if [ ! "$(ls -A $2)"  ]; then
              reportNOK $2 "(empty)"
            else
              reportOK ${2}
            fi
          else
            reportNOK ${2}
          fi
        ;;
        *) reportNOK ${2};;
      esac
    fi
  }


# LOGIC EXECUTION:

  for permType in ${!DIRS2CHECK[@]}
  do
    case ${permType} in
      0) requirement="read";;
      1) requirement="write";;
    esac
    echo -e "Checking ${EMCOL}${requirement^^}${RCOL} permissions:"
    for directory in ${DIRS2CHECK[${permType}]}
    do
      directory=$(readlink -f ${directory})
      checkDir ${requirement} ${directory}
    done
  done

  if [ ${#ERRORS[@]} -eq 0 ]; then
    echo -e "${EMCOL}PASSED${RCOL}: All directories verified OK!"
    exit 0
  else
    echo -e "${EMCOL}FAILED${RCOL}: some directories verified NOK!"
    exit 1
  fi
