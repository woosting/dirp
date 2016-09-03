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

./dirp.sh \
  -r /tmp -r ~ -r /etc -r /root -r ~/tmp \
  -w /tmp -w ~ -w /etc -w /root -w ~/tmp \
  -e /tmp -e ~ -e /etc -e /root -e ~/tmp \

echo -e ""
./dirp.sh \
  -w ~/.storeBackup/sources/target \
  -r ~/.storeBackup/sources/*
