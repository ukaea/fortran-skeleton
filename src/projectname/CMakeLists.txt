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

# Add the source files
FILE(GLOB_RECURSE sources *.f90 *.F90)

# Define the executable in terms of the source files
ADD_EXECUTABLE(${PROJECT_NAME} ${sources})
SET_PROPERTY(TARGET ${PROJECT_NAME} PROPERTY
  Fortran_MODULE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/private_modules)
TARGET_INCLUDE_DIRECTORIES(${PROJECT_NAME}
  PRIVATE
    "${CMAKE_CURRENT_BINARY_DIR}/private_modules"
  )
TARGET_COMPILE_OPTIONS(${PROJECT_NAME} PRIVATE ${DEFAULT_Fortran_FLAGS})
TARGET_LINK_LIBRARIES(${PROJECT_NAME}
  PRIVATE
    ${PROJECT_NAME}::environment ${PROJECT_NAME}::${PROJECT_NAME}_lib
  )

INSTALL(TARGETS ${PROJECT_NAME}
  EXPORT ${PROJECT_NAME}_lib_installation
  ARCHIVE DESTINATION ${LIBDIR}
  LIBRARY DESTINATION ${LIBDIR}
  PUBLIC_HEADER DESTINATION ${INCDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
