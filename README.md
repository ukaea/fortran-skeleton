# Fortran Project Skeleton

This repository provides the skeleton of a Fortran project. It can be
used as a template when beginning a new pice of Fortran software.

## `cmake` Build

Some basic configurations for `cmake` are provided. These are adapted
from the template provided by [Seth Morton on
GitHub](https://github.com/SethMMorton/cmake_fortran_template) and also 
feature a module from [Larse Bilke](https://github.com/bilke/cmake-modules). You
should edit them to suit the needs of your project. In particular,
change the names of executables/libraries, add any additional library 
dependencies, and examine the choice of compiler flags in
`cmake/Modules/SetFortranFlags.cmake`.

## License

UKAEA does not currently have a policy on what licence your code
should be released under. However, the GNU Lesser General Public
License (LGPL) is a good choice. This allows anyone to use and modify
your software providing the derivatives are similarly
licensed. However, unlike the stronger GNU General Public License
(GPL), it still allows unmodified libraries to be used by proprietary
or otherwise differently licensed software. For more on the different
free and open source software licenses available, see
[choosealicense.com](https://choosealicense.com/licenses/).

The texts of the LGPL and GPL (version 3) are included in this template
and should not be deleted if you wish to use this
license. Notifications of licensing are provided at the top of all
example source files. The paragraph below should also be included at
the end of your README file. See the [GNU project for more
details](https://www.gnu.org/licenses/gpl-howto.html) on using their
licenses. __However, the inclusion of (L)GPL documents in this repository
is for the purposes of a providing an example only. The project itself is
not licensed under the LGPL.__ It is licensed under the
[CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/), meaning
it is effectively public domain.
