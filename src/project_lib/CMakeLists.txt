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

# Specify sources for which the resulting module files should be
# available to library users
SET(public_sources type_library.f90)
FOREACH(file ${public_sources})
  GET_FILENAME_COMPONENT(absfile ${file} ABSOLUTE)
  LIST(APPEND public_sources_abs ${absfile})
ENDFOREACH()

# Specify sources for which library users should not be able to access
# the module files
FILE(GLOB_RECURSE private_sources *.f90 *.F90)
LIST(REMOVE_ITEM private_sources ${public_sources_abs})
message(${private_sources})
# Configure target for the private components of the library
ADD_LIBRARY(${PROJECT_NAME}_lib_private STATIC ${private_sources})
SET_PROPERTY(TARGET ${PROJECT_NAME}_lib_private PROPERTY
  Fortran_MODULE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/private_modules")
TARGET_INCLUDE_DIRECTORIES(${PROJECT_NAME}_lib_private
  PUBLIC
    "${CMAKE_CURRENT_BINARY_DIR}/private_modules"
  )
TARGET_COMPILE_OPTIONS(${PROJECT_NAME}_lib_private PRIVATE ${DEFAULT_Fortran_FLAGS})
TARGET_LINK_LIBRARIES(${PROJECT_NAME}_lib_private
  PUBLIC
    ${PROJECT_NAME}::environment
  )

# Configure target for the publicly available parts of the library
ADD_LIBRARY(${PROJECT_NAME}_lib SHARED ${public_sources})
TARGET_COMPILE_OPTIONS(${PROJECT_NAME}_lib PRIVATE ${DEFAULT_Fortran_FLAGS})
SET_PROPERTY(TARGET ${PROJECT_NAME}_lib PROPERTY
  Fortran_MODULE_DIRECTORY include)
SET_PROPERTY(TARGET ${PROJECT_NAME}_lib PROPERTY SOVERSION 0.1)
TARGET_INCLUDE_DIRECTORIES(${PROJECT_NAME}_lib
  PUBLIC
    "$<INSTALL_INTERFACE:include>"
    "$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>")
TARGET_LINK_LIBRARIES(${PROJECT_NAME}_lib
  PUBLIC
    ${PROJECT_NAME}::environment
  PRIVATE
    ${PROJECT_NAME}_lib_private
    ${BUILD_TYPE_Fortran_FLAGS}
  )
ADD_LIBRARY(${PROJECT_NAME}::${PROJECT_NAME}_lib ALIAS ${PROJECT_NAME}_lib)

INSTALL(TARGETS ${PROJECT_NAME}_lib
  EXPORT ${PROJECT_NAME}_installation
  ARCHIVE DESTINATION ${LIBDIR}
  LIBRARY DESTINATION ${LIBDIR}
  PUBLIC_HEADER DESTINATION ${INCDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
