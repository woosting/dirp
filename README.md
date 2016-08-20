# dirchk

This script checks whether directories are accessible.

It looks for a `.dirchkfile` (configurable) in each provided (arguments)
path and marks each path's accesibility based on whether the file was found
or not. When one of the paths was deemed inaccesible the exit status is
restrictively set accordingly (e.g. for followup script to verify).

Copyright 2016 Willem Oosting

>This program is free software: you can redistribute it and/or modify
>it under the terms of the GNU General Public License as published by
>the Free Software Foundation, either version 3 of the License, or
>(at your option) any later version.
>
>This program is distributed in the hope that it will be useful,
>but WITHOUT ANY WARRANTY; without even the implied warranty of
>MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>GNU General Public License for more details.
>
>You should have received a copy of the GNU General Public License
>along with this program.  If not, see <http://www.gnu.org/licenses/>.

FORK ME AT GITHUB: https://github.com/woosting/dirchk
