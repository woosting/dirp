#! /bin/bash
#
# dirc.sh tester
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

echo -e ""
echo "--- MIX results (verbose) ---"
echo -e ""
./dirp.sh -v -e \
  -r /tmp -r ~ -r /etc -r /root -r ~/tmp -r ${HOME}/tmp/emptydir \
  -w /tmp -w ~ -w /etc -w /root -w ~/tmp -w ${HOME}/tmp/emptydir
echo -e ""
echo -e "--- MIX results (normal) ---"
echo -e ""
./dirp.sh -e \
  -r /tmp -r ~ -r /etc -r /root -r ~/tmp -r ${HOME}/tmp/emptydir \
  -w /tmp -w ~ -w /etc -w /root -w ~/tmp -w ${HOME}/tmp/emptydir
echo -e ""
echo -e "--- SUC6 results (normal) ---"
echo -e ""
./dirp.sh \
  -r /tmp -r ~ -r /etc -r ~/tmp \
  -w /tmp -w ~ -w ~/tmp
echo -e ""
echo -e ""
echo -e "--- REAL USECASE (verbose) ---"
echo -e ""
./dirp.sh -v \
  -r "${HOME}/.storeBackup/sources/*" \
  -w "${HOME}/.storeBackup/target/target"
echo -e ""

