#! /bin/bash
#
# This script checks whether directories are accessible (or present).
# It looks for a `.dirchkfile` (configurable) in the root of each provided
# path (arguments) and marks the pahts with an [x] (accessible) when it is
# found. Otherwise it is marked with a [!] (not accessible) and the script
# exits with an errorstatus of "1".
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
# FORK ME AT GITHUB: https://github.com/woosting/dirchk


# CONFIGURATION:
  DIRCHKFILE=".dirchkfile"   # The `directory check file` to detect.

# INITIALISATION:
  DIRS=( "$@" )
  DIRSFOUND=0
  NOTVALIDATED='\033[0;31m'
  VALIDATED='\033[0;32m'
  RC='\033[0m'

# FUNCTION DEFINITION:
  function dirchker() {
    if [ -f ${1}/${DIRCHKFILE} ]
      then
      	echo -e "${VALIDATED}[x]$RC $1"
      	DIRSFOUND=$((DIRSFOUND + 1))
      else
      	echo -e "${NOTVALIDATED}[!]$RC $1"
    fi
  }
  function resultHandler() {
    echo -e "";
    if [ ${DIRSFOUND} ==  ${#DIRS[@]} ]
      then
        exit 0;
    fi
  }


# LOGIC EXECUTION:
if [ ${#DIRS[@]} -ge 1 ]
  then
    if [ ${DIRCHKFILE} ]
      then
        echo -e "Checking directory access..."
      else
        echo -e "ERROR: Please specify a DIRCHKFILE (the file to detect) in the config section!\n"
        exit 1;
    fi
    for i in ${DIRS[*]}; do
      dirchker $i
    done
  else
    echo -e "NOTHING TO CHECK: Please supply at least one directory (argument) to check!\n"
    exit 1;
fi
resultHandler
exit 1;
