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
  DEBUG=1


# INITIALISATION:

  ERRORS=()
  DIRSOK=0


# FUNCTION DEFINITION:

  
  function reportOK() {
    DIRSOK=$((DIRSOK + 1))
    echo -e "${OKCOL}[\u2713]$RCOL ${1}"

  }

  function reportNOK() {
    ERRORS+=("${1} verified NOK: ${2}")
    echo -e "${NOKCOL}[!]$RCOL ${1} ${2}"
  }

  function checkIfDir() {
    if [ ! -d "$1" ]; then
      reportNOK $1 "(not a directory)"
    else
      reportOK $1
    fi
  }

  function checkIfContent {
    if [ ! "$(ls -A ${1})"  ]; then
      reportNOK ${1} "(empty)"
    else
      reportOK ${1}
    fi
  }


  function checkPerm {
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
        case ${requirement} in
          read)
            if [ -r "${directory}" ]; then
              reportOK ${directory}
            else
              reportNOK ${directory}
            fi
          ;;
          write)
            if [ -w "${directory}" ]; then
              reportOK ${directory}
            else
              reportNOK ${directory}
            fi
          ;;
          *) reportNOK ${directory};;
        esac
      done
    done
  }

  function resultHandler {
    if [ ${DIRSOK} -ne ${TOTALNRDIRS2CHECK} ]; then
      echo -e "${EMCOL}FAILED${RCOL}: some directories verified NOK!"
      exit 1
    else
      echo -e "${EMCOL}PASSED${RCOL}: All directories verified OK!"
      exit 0
    fi
   }

  function debugReport {
    if [ ${DEBUG} -eq "1" ]; then
      echo -e "-----------------"
      echo -e "DIRS OK:    ${DIRSOK}"
      echo -e "ERRORS:     ${#ERRORS[@]}"
      echo -e ""
      echo -e "DIRS TOTAL: ${TOTALNRDIRS2CHECK}"
      echo -e "-----------------"
    fi
  }

# LOGIC EXECUTION:

  while getopts r:w: option
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
  TOTALNRDIRS2CHECK=$((${#DIRS2READ[@]}+${#DIRS2WRITE[@]}))
  if [ ${TOTALNRDIRS2CHECK} -eq 0 ]; then
    echo -e "USAGE: dirp [-r /path] [-w /path]"
    exit 1;
  fi

  checkPerm
  debugReport
  resultHandler
