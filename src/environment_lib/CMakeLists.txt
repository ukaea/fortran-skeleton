#
# CMakeLists.txt
# This file is part of PROJECTNAME.
#
# Copyright YEAR AUTHOR <EMAIL> [AUTHOR2 <EMAIL2>, ...]
#  
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this program.  If not, see
# <https://www.gnu.org/licenses/>.
#

#
# This file is adapted from cmake_fortran_template
# <https://github.com/SethMMorton/cmake_fortran_template>
# Copyright (c) 2018 Seth M. Morton
#

FILE(GLOB_RECURSE sources *.f90 *.F90)
ADD_LIBRARY(environment STATIC ${sources})
TARGET_COMPILE_OPTIONS(environment PRIVATE ${DEFAULT_Fortran_FLAGS})
SET(MODDIR ${CMAKE_CURRENT_BINARY_DIR}/include)
SET(INCDIR ${INCDIR}/environment)
SET_PROPERTY(TARGET environment PROPERTY Fortran_MODULE_DIRECTORY ${MODDIR})
TARGET_INCLUDE_DIRECTORIES(environment
  PUBLIC
    "$<INSTALL_INTERFACE:${INCDIR}>"
    "$<BUILD_INTERFACE:${MODDIR}>")
ADD_LIBRARY(${PROJECT_NAME}::environment ALIAS environment)

INSTALL(TARGETS environment
  EXPORT ${PROJECT_NAME}_installation
  ARCHIVE DESTINATION ${LIBDIR}
  LIBRARY DESTINATION ${LIBDIR}
  PUBLIC_HEADER DESTINATION ${INCDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
INSTALL(DIRECTORY ${MODDIR}/
  DESTINATION ${INCDIR})
