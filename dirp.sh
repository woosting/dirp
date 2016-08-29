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

  EMCOL='\033[1m'                 #EMPHASIS color (default: BOLD)
  NOKCOL='\033[0;31m'             #NOT OK color (default: RED)
  OKCOL='\033[0;32m'              #OK color (default: GREEN)
  RCOL='\033[0m'                  #RESET color (default: terminal default)


# INITIALISATION:

  # STATICS

    DIRSOK=0
    PERMCRIT=7
    DIRS2CHK=0
    DIRPERMS="NOK"

  # ARGUMENT INTAKE

    while getopts c:x: option      #FLAGGED
      do
        case "${option}"
         in
          c) PERMCRIT=${OPTARG};;
          x) EXAMPLE=${OPTARG};;
        esac
      done
    DIRS2CHK=${@:$OPTIND}            #NON-FLAGGED


# FUNCTION DEFINITION:

  function checkInput() {
    if [ ${#DIRS2CHK[@]} -ge 1 ]
      then
        echo -e "Checking directory permissions..."
      else
        echo -e "${EMCOL}NOTHING TO CHECK$RCOL: Please supply at least one directory as an argument:"
        echo -e "For example: #$ dirp /path/directoryToCheck"
        exit 1;
    fi
  }
  function calcPerm() {
    PERM=0
    test -r $1 && PERM=$((PERM + 4))
    test -w $1 && PERM=$((PERM + 2))
    test -x $1 && PERM=$((PERM + 1))
  }
  function chkPerm() {
    if [ ${PERM} -ge ${PERMCRIT} ]
      then
        echo -e "${OKCOL}[x]$RCOL $1"
        DIRSOK=$((DIRSOK + 1))
      else
        echo -e "${NOKCOL}[!]$RCOL $1"
    fi
  }
  function resultHandler() {
    if [ ${DIRSOK} ==  ${#DIRS2CHK[@]} ]
      then
        echo -e "${EMCOL}PASSED${RCOL}: All dirs meet perm level ${PERMCRIT}."
        DIRPERMS="OK"
        exit 0;
      else
        echo -e "${EMCOL}FAILED${RCOL}: One or more dirs did NOT meet perm level ${PERMCRIT}!"
        exit 1;
    fi
  }


# LOGIC EXECUTION:

  checkInput
  for i in ${DIRS2CHK[*]}; do
    calcPerm $i
    chkPerm $i
  done
  resultHandler
  exit 1;
