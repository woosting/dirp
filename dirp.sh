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


# CONFIGURATION:

  EMCOL='\033[1m'    #EMPHASIS color (default: BOLD)
  NOKCOL='\033[0;31m' #NOT OK color (default: RED)
  OKCOL='\033[0;32m' #OK color (default: GREEN)
  RCOL='\033[0m'    #RESET color (default: terminal default)


# INITIALISATION:

  DIRSOK=0
  EMPTYCHECK=0
  VERBOSELVL=0
  DEBUG=0
  REPORTCHAR="!"

  function getInput () {
    local OPTIND r w e v d option
    while getopts r:w:evd option
    do
      case "${option}"
       in
        r) DIRS2READ+=(${OPTARG});;
        w) DIRS2WRITE+=(${OPTARG});;
        e) EMPTYCHECK=1;;
        v) VERBOSELVL=1;;
        d) DEBUG=1;;
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
      echo -e "USAGE: dirp -r|w \"/path [/path2]\" [...] [-e] [-v]"
      echo -e "         -r Read permission check (for quoted paths)"
      echo -e "         -w Write permission check (for quoted paths)"
      echo -e "         -e Empty checks (additional errors if empty)"
      echo -e "         -v Verbose mode (providing more feedback)"
      exit 1;
    fi
  }


# FUNCTION DEFINITION:

  function reportOK() {
    DIRSOK=$((DIRSOK + 1))
    if [ ${VERBOSELVL} -ge 1 ]; then
      echo -e "${OKCOL}[\u2713]$RCOL ${1}"
    fi
  }

  function reportNOK() {
    ERRORS+=("${1} verified NOK: ${2}")
    echo -e "${NOKCOL}[${REPORTCHAR}]$RCOL ${1} ${2}"
  }

  function checkIfEmpty {
    if [ ! "$(ls -A ${1})"  ]; then
      REPORTCHAR="e"
      reportNOK ${1} "(empty)"
    else
      reportOK ${1}
    fi
  }

  function checkPerm {
    for permType in ${!DIRS2CHECK[@]} 
    do
      case ${permType} in
        0)
          requirement="read"
          REPORTCHAR="r"
        ;;
        1)
          requirement="write"
          REPORTCHAR="w"
        ;;
      esac
      if [ ${VERBOSELVL} -ge 1 ]; then
        echo -e "${requirement^^}..."
      fi
      for directory in ${DIRS2CHECK[${permType}]}
      do
        directory=$(readlink -f ${directory})
        case ${requirement} in
          read)
            if [ ! -d "${directory}" ]; then
              REPORTCHAR="d"
              reportNOK ${directory} "(not a directory)"
            else
              if [ -r "${directory}" ]; then
                if [ ${EMPTYCHECK} -eq 1 ]; then
                  checkIfEmpty ${directory}
                else
                  reportOK ${directory}
                fi
              else
                reportNOK ${directory}
              fi
            fi
          ;;
          write)
            if [ ! -d "${directory}" ]; then
              REPORTCHAR="d"
              reportNOK ${directory} "(not a directory)"
            else
              if [ -w "${directory}" ]; then
                if [ ${EMPTYCHECK} -eq 1 ]; then
                  checkIfEmpty ${directory}
                else
                  reportOK ${directory}
                fi                
              else
                reportNOK ${directory}
              fi
            fi
          ;;
          *) reportNOK ${directory};;
        esac
      done
    done
  }

  function resultHandler {
    if [ ${DIRSOK} -eq ${TOTALNRDIRS2CHECK} ]; then
      if [ ${VERBOSELVL} -ge 1 ]; then
        echo -e "------------------------------------"
      fi
      echo -e "${EMCOL}PASSED${RCOL}: All directories verified OK!"
      exit 0
    else
      if [ ${VERBOSELVL} -ge 1 ]; then
        echo -e "--------------------------------------"
      fi
      echo -e "${EMCOL}FAILED${RCOL}: some directories verified NOK!"
      exit 1
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

  getInput "$@"
  checkPerm
  debugReport
  resultHandler
