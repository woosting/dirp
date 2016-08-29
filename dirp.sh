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
  DIRSOK=0                      #DEFAULT   (strict)
  PERMCRIT=7                    #DEFAULT   (cumulatively: read=4 write=2 execute=1)
  DIRPERMS="NOK"

  while getopts r:w: option; do  #CL-INTAKE (flagged arguments)
    case "${option}"
     in
      r) DIRS2READ+=(${OPTARG});;
      w) DIRS2WRITE+=(${OPTARG});;
      x) EXAMPLE=${OPTARG};;
    esac
  done
  if [ ${#DIRS2READ[@]} -ge 1 ]; then
    DIRS2CHK[5]=${DIRS2READ[@]}
  fi
  if [ ${#DIRS2WRITE[@]} -ge 1 ]; then
    DIRS2CHK[7]=${DIRS2WRITE[@]}
  fi
  if [ ${#DIRS2CHK[@]} -eq 0 ]; then
    echo -e "${EMCOL}UNKNOWN WHAT TO CHECK$RCOL: Please supply at least one criteroim (-r|w) with a directory path to check!"
    echo -e "For example: #$ dirp -r /path/directoryToCheck"
    exit 1;
  fi

# FUNCTION DEFINITION:

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

#checkInput @fixme

for permission in ${!DIRS2CHK[@]}
do
    echo Checking permission level ${permission}:
    PERMCRIT=${permission}
    for directory in ${DIRS2CHK[${permission}]}
    do
        calcPerm ${directory}
        chkPerm ${directory}
    done
done

resultHandler

exit 1;
