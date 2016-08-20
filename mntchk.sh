#! /bin/bash
#
# This script checks whether mount points are mounted:
#
# It looks for the presence of a `.mntchkfile` (configuratble) in root of the
# provided (arguments) mount point targets. It only deems the targets mounted
# when it finds the file. Otherwise it *stricktly* exits with an errorcode.
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
# FORK ME AT GITHUB: https://github.com/woosting/mntchk


# CONFIGURATION:
  MNTCHKFILE=".mntchkfile"  # The `mount check file` to detect.
  ERROR='\033[0;31m'        # Error status color (default: red)
  READY='\033[0;32m'        # Ready status color (default: green)

# INITIALISATION:
  MOUNTS=( "$@" )
  MOUNTSFOUND=0
  RC='\033[0m'

# FUNCTION DEFINITION:
  function mntchker() {
    if [ -f ${1}/${MNTCHKFILE} ]
      then
      	echo -e "${READY}[x]$RC $1"
      	MOUNTSFOUND=$((MOUNTSFOUND + 1))
      else
      	echo -e "${ERROR}[!]$RC $1"
    fi
  }
  function resultHandler() {
    echo -e "";
    if [ ${MOUNTSFOUND} ==  ${#MOUNTS[@]} ]
      then
        exit 0;
    fi
  }


# LOGIC EXECUTION:
if [ ${#MOUNTS[@]} -ge 1 ]
  then
    echo -e "Checking..."
    for i in ${MOUNTS[*]}; do
      mntchker $i
    done
  else
    echo -e "NOTHING TO CHECK: Please supply at least one mount point (argument) to check!\n"
    exit 1;
fi
resultHandler
exit 1;
