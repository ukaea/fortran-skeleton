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

CMAKE_MINIMUM_REQUIRED(VERSION 2.8.5)

PROJECT(projectname)
ENABLE_LANGUAGE(Fortran)

# Set the version of your software
SET(VERSION 0.0.1)

# Add our local modlues to the module path
SET(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/Modules")

# All new projects should use Fortran 90 features
IF(NOT CMAKE_Fortran_COMPILER_SUPPORTS_F90)
    MESSAGE(FATAL_ERROR "Fortran compiler does not support F90")
ENDIF(NOT CMAKE_Fortran_COMPILER_SUPPORTS_F90)

# Optionally set a parallelization library. Uncomment as desired.
#OPTION(USE_MPI "Use the MPI library for parallelization" OFF)
#OPTION(USE_OPENMP "Use OpenMP for parallelization" OFF)

# This INCLUDE statement executes code that sets the compile flags for DEBUG,
# RELEASE, and TESTING.  You should  review this file and make sure the flags 
# are to your liking.
INCLUDE(${CMAKE_MODULE_PATH}/SetFortranFlags.cmake) 

# Locate and set parallelization libraries.  There are some CMake peculiarities
# taken care of here, such as the fact that the FindOpenMP routine doesn't know
# about Fortran. Uncomment if using parallel programming features.
#INCLUDE(${CMAKE_MODULE_PATH}/SetParallelizationLibrary.cmake)

# Setup the LAPACK libraries.  This also takes care of peculiarities, such as
# the fact the searching for MKL requires a C compiler, and that the results
# are not stored in the cache.  Uncomment if using LAPACK routines.
#INCLUDE(${CMAKE_MODULE_PATH}/SetUpLAPACK.cmake)

# There is an error in CMAKE with this flag for pgf90.  Unset it
GET_FILENAME_COMPONENT(FCNAME ${CMAKE_Fortran_COMPILER} NAME)
IF(FCNAME STREQUAL "pgf90")
    UNSET(CMAKE_SHARED_LIBRARY_LINK_Fortran_FLAGS)
ENDIF(FCNAME STREQUAL "pgf90")

############################################################
# Define the actual files and folders that make up the build
############################################################

# Define the executable name
SET(MAIN_EXE ${CMAKE_PROJECT_NAME})

# Define the library names
SET(PROJECT_LIB project_lib)
SET(ENV_LIB environment_lib)

# Define the name of the unit test binary
SET(TEST_EXE unittests)

# Define some directories
SET(SRC_DIR ${CMAKE_SOURCE_DIR}/src)
SET(LIB_DIR ${CMAKE_SOURCE_DIR}/lib)
SET(INC_DIR ${CMAKE_SOURCE_DIR}/include)
SET(BIN_DIR ${CMAKE_SOURCE_DIR}/bin)
SET(SRC_MAIN ${SRC_DIR}/${MAIN_EXE})
SET(SRC_LIB ${SRC_DIR}/${PROJECT_LIB})
SET(SRC_ENV ${SRC_DIR}/${ENV_LIB})
SET(SRC_TESTS ${CMAKE_SOURCE_DIR}/tests)

SET(CMAKE_Fortran_MODULE_DIRECTORY ${INC_DIR}) # Have the .mod files placed in the include folder
SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${BIN_DIR})
SET(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${LIB_DIR})

# The source for the main binary
ADD_SUBDIRECTORY(${SRC_MAIN})

# The source for the libraries
ADD_SUBDIRECTORY(${SRC_LIB})
ADD_SUBDIRECTORY(${SRC_ENV})

# Add the source for the unit tests
ADD_SUBDIRECTORY(${SRC_TESTS})

# Add a distclean target to the Makefile
ADD_CUSTOM_TARGET(distclean 
    COMMAND ${CMAKE_COMMAND} -P ${CMAKE_SOURCE_DIR}/distclean.cmake
)
