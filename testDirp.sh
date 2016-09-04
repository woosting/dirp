#! /bin/bash
#
# dirp.sh tester
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

clear
echo "--- MIXED results (verbose) ---"
./dirp.sh -v -e \
  -r /tmp -r ~ -r /etc -r /root -r ~/tmp -r ${HOME}/tmp/emptydir -r ${HOME}/tmp/file \
  -w /tmp -w ~ -w /etc -w /root -w ~/tmp -w ${HOME}/tmp/emptydir -w ${HOME}/tmp/file
echo -e ""
echo -e "--- MIXED results (normal) ---"
./dirp.sh -e \
  -r /tmp -r ~ -r /etc -r /root -r ~/tmp -r ${HOME}/tmp/emptydir -r ${HOME}/tmp/file \
  -w /tmp -w ~ -w /etc -w /root -w ~/tmp -w ${HOME}/tmp/emptydir -w ${HOME}/tmp/file
echo -e ""
echo -e "--- SUCCESS only (normal) ---"
./dirp.sh \
  -r /tmp -r ~ -r /etc -r ~/tmp \
  -w /tmp -w ~ -w ~/tmp
echo -e ""
echo -e "--- REALISTIC (verbose) ---"
./dirp.sh -e -v \
  -r "${HOME}/.storeBackup/sources/*" \
  -w "${HOME}/.storeBackup/target/target"
echo -e ""
echo -e "--- REALISTIC (normal) ---"
./dirp.sh -e \
  -r "${HOME}/.storeBackup/sources/*" \
  -w "${HOME}/.storeBackup/target/target"
