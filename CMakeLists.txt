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

CMAKE_MINIMUM_REQUIRED(VERSION 3.0.0)

PROJECT(projectname VERSION 0.0.1
  DESCRIPTION "A Fortran project"
  LANGUAGES Fortran)
#ENABLE_LANGUAGE(Fortran)

# Add our local modlues to the module path
SET(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/Modules")

# All new projects should use Fortran 90 features
IF(NOT CMAKE_Fortran_COMPILER_SUPPORTS_F90)
    MESSAGE(FATAL_ERROR "Fortran compiler does not support F90")
ENDIF(NOT CMAKE_Fortran_COMPILER_SUPPORTS_F90)

# This INCLUDE statement executes code that sets the compile flags for
# DEBUG, RELEASE, and TESTING, stored in the variables
# DEFAULT_Fortran_FLAGS_{DEBUG,RELEASE,TESTING}.  The flags for your
# build type are available in the variable DEFAULT_Fortran_FLAGS.  You
# should review this file and make sure the flags are to your liking.
# DEFAULT_Fortran_FLAGS should be used to set flags for each target
# individually (rather than globally for the whole project).  This
# will allow for better granularity of control over compiler options.
INCLUDE(${CMAKE_MODULE_PATH}/SetFortranFlags.cmake)


# Thie INCLUDE statement provides a set of functions to set up code
# coverage reports
INCLUDE(${CMAKE_MODULE_PATH}/CodeCoverage.cmake)

# There is an error in CMAKE with this flag for pgf90.  Unset it
GET_FILENAME_COMPONENT(FCNAME ${CMAKE_Fortran_COMPILER} NAME)
IF(FCNAME STREQUAL "pgf90")
    UNSET(CMAKE_SHARED_LIBRARY_LINK_Fortran_FLAGS)
ENDIF(FCNAME STREQUAL "pgf90")

############################################################
# Define the actual files and folders that make up the build
############################################################

INCLUDE(GNUInstallDirs)

# Define the name of the unit test binary
SET(TEST_EXE unittests)
SET(LIBDIR ${CMAKE_INSTALL_LIBDIR}/${PROJECT_NAME})
SET(INCDIR ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME})

# The source for the libraries
ADD_SUBDIRECTORY(${CMAKE_SOURCE_DIR}/src/environment_lib)
ADD_SUBDIRECTORY(${CMAKE_SOURCE_DIR}/src/project_lib)

# The source for the main binary
ADD_SUBDIRECTORY(${CMAKE_SOURCE_DIR}/src/${PROJECT_NAME})

# Add the source for the unit tests
ADD_SUBDIRECTORY(${CMAKE_SOURCE_DIR}/tests)

# Build the documentation

# Export this project for use by others
SET(INSTALL_CONFIGDIR ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME})
INSTALL(EXPORT ${PROJECT_NAME}_installation
  FILE
    ${PROJECT_NAME}Targets.cmake
  NAMESPACE
    ${PROJECT_NAME}::
  DESTINATION
    ${INSTALL_CONFIGDIR}
  )

INCLUDE(CMakePackageConfigHelpers)
WRITE_BASIC_PACKAGE_VERSION_FILE(
    ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY SameMajorVersion
)

CONFIGURE_PACKAGE_CONFIG_FILE(${CMAKE_CURRENT_LIST_DIR}/cmake/${PROJECT_NAME}Config.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
    INSTALL_DESTINATION ${INSTALL_CONFIGDIR}
    PATH_VARS INSTALL_CONFIGDIR
)

#Install the config and configversion files
install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
    DESTINATION ${INSTALL_CONFIGDIR}
)


# Add a distclean target to the Makefile
ADD_CUSTOM_TARGET(distclean 
    COMMAND ${CMAKE_COMMAND} -P ${CMAKE_SOURCE_DIR}/distclean.cmake
)
