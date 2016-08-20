# mntchk

This script checks whether mount points are mounted:

It looks for the presence of a `.mntchkfile` (configuratble) in root of the
provided (arguments) mount point targets. It only deems the targets mounted
when it finds the file. Otherwise it *stricktly* exits with an errorcode.

Copyright 2016 Willem Oosting

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.

FORK ME AT GITHUB: https://github.com/woosting/mntchk
