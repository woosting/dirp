#! /bin/bash
#
# # DIRectory series Permission checker (DIRP)
#
# Takes in the argument -c (criterion for the permission to check on):
# - 7 (rwx) 
# - 6 (rw-)
# - 5 (r-x) 
# - 4 (r--) 
# - 3 (-wx)
# - 2 (-w-)
# - 1 (--x)
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

  EMCOL='\033[1m'               #EMPHASIS color (default: BOLD)
  NOKCOL='\033[0;31m'           #NOT OK color (default: RED)
  OKCOL='\033[0;32m'            #OK color (default: GREEN)
  RCOL='\033[0m'                #RESET color (default: terminal default)


# INITIALISATION:

  DIRSOK=0                      #DEFAULT   (strict)
#  DIRS2CHK=( "$@" )             #CL-INTAKE (non-flaged arguments)
  PERMCRIT=7                    #DEFAULT   (cumulatively: read=4 write=2 execute=1)
  while getopts c:d: option     #CL-INTAKE (flagged arguments)
    do
      case "${option}"
       in
        c) PERMCRIT=${OPTARG};;
        d) DIRS2CHK=( "${OPTARG}" ) ;;
      esac
    done


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
        PERMCHECK=1
      else
        PERMCHECK=0
    fi
  }
  function chkDir() {
    if [ ${PERMCHECK} == 1 ]
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
    chkDir $i
  done
  resultHandler
  exit 1;
