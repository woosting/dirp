#! /bin/bash
#
# Script to determine whether mounts are present for backups.
#
# VERSION:
#          0.03 - 2016/08/20
#          - Added explicit check for thie existence of an .mntchkfile
#          - Taking in arguments as mountpoints to check.
#          0.02 - 2016/06/03
#          - Made backups mount generic
#          - Added FAYNTIC to the list
#          - Added version history contents
#          - Removed AYA from the list
#          0.01
#          - First opreational version

# CONFIG

MOUNTS=( "$@" )
#  MOUNTS[0]="/mnt/backups"
#  MOUNTS[1]="/mnt/backups-offsite"
#  MOUNTS[2]="/mnt/ch3snas"
#  MOUNTS[3]="/mnt/fayntic"


# VARIABLES

  MNTCHKFILE=".mntchkfile"
  MOUNTSFOUND=0

  # color definitions
  # syntax: echo -e "\033[1;32m\033[44m test \033[0m"
  #                  foreground backgr       reset
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  RC='\033[0m' # Reset color


# FUNCTIONS 

  function mntchk() {
    if [ -f ${1}/${MNTCHKFILE} ]
      then
      	echo -e "${GREEN}[x]$RC $1"
      	MOUNTSFOUND=$((MOUNTSFOUND + 1))
      else
      	echo -e "$RED[!]$RC $1"
    fi
  }


# EXECUTION LOGIC

if [ ${#MOUNTS[@]} -ge 1 ]
  then
    echo -e "\nMount availability checking...\n"
    for i in ${MOUNTS[*]}; do
      mntchk $i
    done
    echo "";

    if [ ${MOUNTSFOUND} !=  ${#MOUNTS[@]} ]
      then
        echo -e "MOUNTS NOT ALL READY!${RC}\n"
        exit 1;
      else
        echo -e "Mounts all ready.\n"
    fi
  else
    echo -e "\nERROR: Please supply at least one argument (mount point)!\n"
    exit 1;
fi


# LEGACY
#
#  echo "-/mnt/backups"
#  ls /mnt/backups/;
#  echo ""
#  echo "-/mnt/backups-offsite"
#  ls /mnt/backups-offsite/;
#  echo ""
#  echo "-/mnt/ch3snas"
#  ls /mnt/ch3snas/;
#  echo ""
#  echo "-/mnt/fayntic"
#  ls /mnt/fayntic/;
#  echo ""
