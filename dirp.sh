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
ERRORS=()

while getopts r:w: option     #CL-INTAKE (flagged arguments)
do
  case "${option}"
   in
    r) READABLE_DIRS+=(${OPTARG});;
    w) WRITABLE_DIRS+=(${OPTARG});;
  esac
done

if [ ${#READABLE_DIRS[@]} -gt 0 ]; then
    DIRECTORIES[0]=${READABLE_DIRS[@]}
fi

if [ ${#WRITABLE_DIRS[@]} -gt 0 ]; then
    DIRECTORIES[1]=${WRITABLE_DIRS[@]}
fi

if [ ${#DIRECTORIES[@]} -eq 0 ]; then
    echo -e "USAGE: dirp [-r /path] [-w /path]"
    echo -e
    echo -e "Input arguments are missing. Please check USAGE."
    exit 1;
fi

# FUNCTION DEFINITION:
function permissionOk() {
    echo -e "${OKCOL}[\u2713]$RCOL ${1}"
}

function permissionError() {
    ERRORS+=("${2} doesn't meet the requirement of ${1} (is ${PERM})")
    echo -e "${NOKCOL}[!]$RCOL ${1}"
}

function chkPerm() {
    case ${1} in
        read)
            if [ -r "${2}" ]; then
                permissionOk ${2}
            else
                permissionError ${2}
            fi
        ;;
        write)
            if [ -w "${2}" ]; then
                    permissionOk ${2}
                else
                    permissionError ${2}
                fi
            ;;
        *) permissionError ${2};;
     esac
}

# LOGIC EXECUTION:
echo -e "Checking directory permissions..."

for permission in ${!DIRECTORIES[@]}
do
    case ${permission} in
        0) requirement=read;;
        1) requirement=write;;
    esac

    echo -e "Checking ${EMCOL}${requirement^^}${RCOL} permissions for:"

    for directory in ${DIRECTORIES[${permission}]}
    do
        directory=$(readlink -f ${directory})

        if [ ! -d "${directory}" ]; then
            echo -e "ERROR: The specified argument '${directory}' is not a directory."
            exit 1
        fi

        chkPerm ${requirement} ${directory}
    done
done

if [ ${#ERRORS[@]} -eq 0 ]; then
    echo -e "${EMCOL}PASSED${RCOL}"

    exit 0
else
    echo -e "${EMCOL}FAILED${RCOL}"

    exit 1
fi
