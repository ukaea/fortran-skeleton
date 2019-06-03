######################################################
# Determine and set the Fortran compiler flags we want 
######################################################

####################################################################
# Make sure that the default build type is RELEASE if not specified.
####################################################################
INCLUDE(${CMAKE_MODULE_PATH}/SetCompileFlag.cmake)

# Make sure the build type is uppercase
STRING(TOUPPER "${CMAKE_BUILD_TYPE}" BT)

IF(BT STREQUAL "RELEASE")
    SET(CMAKE_BUILD_TYPE RELEASE CACHE STRING
      "Choose the type of build, options are DEBUG, RELEASE, or TESTING."
      FORCE)
ELSEIF(BT STREQUAL "DEBUG")
    SET (CMAKE_BUILD_TYPE DEBUG CACHE STRING
      "Choose the type of build, options are DEBUG, RELEASE, or TESTING."
      FORCE)
ELSEIF(BT STREQUAL "TESTING")
    SET (CMAKE_BUILD_TYPE TESTING CACHE STRING
      "Choose the type of build, options are DEBUG, RELEASE, or TESTING."
      FORCE)
ELSEIF(NOT BT)
    SET(CMAKE_BUILD_TYPE RELEASE CACHE STRING
      "Choose the type of build, options are DEBUG, RELEASE, or TESTING."
      FORCE)
    MESSAGE(STATUS "CMAKE_BUILD_TYPE not given, defaulting to RELEASE")
ELSE()
    MESSAGE(FATAL_ERROR "CMAKE_BUILD_TYPE not valid, choices are DEBUG, RELEASE, or TESTING")
ENDIF(BT STREQUAL "RELEASE")

#########################################################
# If the compiler flags have already been set, return now
#########################################################

IF(DEFAULT_Fortran_FLAGS_RELEASE AND DEFAULT_Fortran_FLAGS_TESTING AND
   DEFAULT_Fortran_FLAGS_DEBUG AND DEFAULT_Fortran_FLAGS)
  SEPARATE_ARGUMENTS(DEFAULT_Fortran_FLAGS)
  SEPARATE_ARGUMENTS(DEFAULT_Fortran_FLAGS_RELEASE)
  SEPARATE_ARGUMENTS(DEFAULT_Fortran_FLAGS_TESTING)
  SEPARATE_ARGUMENTS(DEFAULT_Fortran_FLAGS_DEBUG)
  RETURN ()
ENDIF(DEFAULT_Fortran_FLAGS_RELEASE AND DEFAULT_Fortran_FLAGS_TESTING AND
      DEFAULT_Fortran_FLAGS_DEBUG AND DEFAULT_Fortran_FLAGS)

UNSET(DEFAULT_Fortran_FLAGS_RELEASE CACHE)
UNSET(DEFAULT_Fortran_FLAGS_TESTING CACHE)
UNSET(DEFAULT_Fortran_FLAGS_DEBUT CACHE)
UNSET(DEFAULT_Fortran_FLAGS CACHE)

########################################################################
# Determine the appropriate flags for this compiler for each build type.
# For each option type, a list of possible flags is given that work
# for various compilers.  The first flag that works is chosen.
# If none of the flags work, nothing is added (unless the REQUIRED 
# flag is given in the call).  This way unknown compiles are supported.
#######################################################################

#####################
### GENERAL FLAGS ###
#####################

# Don't add underscores in symbols for C-compatability
SET_COMPILE_FLAG(DEFAULT_Fortran_FLAGS "${DEFAULT_Fortran_FLAGS}"
                 Fortran "-fno-underscoring")

# There is some bug where -march=native doesn't work on Mac
IF(APPLE)
    SET(GNUNATIVE "-mtune=native")
ELSE()
    SET(GNUNATIVE "-march=native")
ENDIF()
# Optimize for the host's architecture
SET_COMPILE_FLAG(DEFAULT_Fortran_FLAGS "${DEFAULT_Fortran_FLAGS}"
                 Fortran "-xHost"        # Intel
                         "/QxHost"       # Intel Windows
                         ${GNUNATIVE}    # GNU
                         "-ta=host"      # Portland Group
                )

# Turn on all warnings 
SET_COMPILE_FLAG(DEFAULT_Fortran_FLAGS "${DEFAULT_Fortran_FLAGS}"
                 Fortran "-warn all" # Intel
                         "/warn:all" # Intel Windows
                         "-Wall"     # GNU
                                     # Portland Group (on by default)
                )
SET_COMPILE_FLAG(DEFAULT_Fortran_FLAGS "${DEFAULT_Fortran_FLAGS}"
                 Fortran "-Wextra"   # GNU
                )
SET_COMPILE_FLAG(DEFAULT_Fortran_FLAGS "${DEFAULT_Fortran_FLAGS}"
                 Fortran "-Wsurprising" # GNU
                )
SET_COMPILE_FLAG(DEFAULT_Fortran_FLAGS "${DEFAULT_Fortran_FLAGS}"
                 Fortran "-Wpedantic"   # GNU
                )

# Treat warnings as errors
SET_COMPILE_FLAG(DEFAULT_Fortran_FLAGS "${DEFAULT_Fortran_FLAGS}"
                 Fortran "-warn error" # Intel
                         "/warn:error" # Intel Windows
                         "-Werror"     # GNU
                                       # Portland Group (not available)
                )

# Require code to be standard-complient
SET_COMPILE_FLAG(DEFAULT_Fortran_FLAGS "${DEFAULT_Fortran_FLAGS}"
                 Fortran "-stand=f18"   # Intel
                         "-stand=f15"   # Old versions of Intel
                         "-stand=f08"   # Even older versions of Intel
                         "-std=f2018"   # GNU
                         "-std=f2008ts" # Old versions of GNU
                         "-std=f2008"   # Even older versions of GNU
                         "-Mstandard"   # Portland Group
                )

SEPARATE_ARGUMENTS(DEFAULT_Fortran_FLAGS)

###################
### DEBUG FLAGS ###
###################

# NOTE: debugging symbols (-g or /debug:full) are already on by default

# Disable optimizations
SET_COMPILE_FLAG(DEFAULT_Fortran_FLAGS_DEBUG "${DEFAULT_Fortran_FLAGS_DEBUG}"
                 Fortran REQUIRED "-O0" # All compilers not on Windows
                                  "/Od" # Intel Windows
                )
	      
# Traceback
SET_COMPILE_FLAG(DEFAULT_Fortran_FLAGS_DEBUG "${DEFAULT_Fortran_FLAGS_DEBUG}"
                 Fortran "-traceback"   # Intel/Portland Group
                         "/traceback"   # Intel Windows
                         "-fbacktrace"  # GNU (gfortran)
                         "-ftrace=full" # GNU (g95)
                )

# Check array bounds, pointers, recursion, etc. (varies by compiler)
SET_COMPILE_FLAG(DEFAULT_Fortran_FLAGS_DEBUG "${DEFAULT_Fortran_FLAGS_DEBUG}"
                 Fortran "-check all"     # Intel
                         "/check:all"     # Intel Windows
                         "-fcheck=all"    # GNU (New style)
                         "-fbounds-check" # GNU (Old style)
                         "-Mbounds"       # Portland Group
                )
SET_COMPILE_FLAG(DEFAULT_Fortran_FLAGS_DEBUG "${DEFAULT_Fortran_FLAGS_DEBUG}"
                 Fortran "-chkptr"        # Portland Group
                )
SET_COMPILE_FLAG(DEFAULT_Fortran_FLAGS_DEBUG "${DEFAULT_Fortran_FLAGS_DEBUG}"
                 Fortran "-chkstk"        # Portland Group
                )

# Check for various floating point errors
SET_COMPILE_FLAG(DEFAULT_Fortran_FLAGS_DEBUG "${DEFAULT_Fortran_FLAGS_DEBUG}"
                 Fortran "-fpe-all=0"                       # Intel
                         "/fpe-all=0"                       # Intel Windows
                         "-ffpe-trap=invalid,zero,overflow" # GNU
                         "-Ktrap=fp,inv,ovf"                # Portland Group
                )

SEPARATE_ARGUMENTS(DEFAULT_Fortran_FLAGS_DEBUG)

#####################
### TESTING FLAGS ###
#####################

# Optimizations
SET_COMPILE_FLAG(DEFAULT_Fortran_FLAGS_TESTING "${DEFAULT_Fortran_FLAGS_TESTING}"
                 Fortran REQUIRED "-O2" # All compilers not on Windows
                                  "/O2" # Intel Windows
                )

# Coverage flags (only available for GNU and Intel Windows)
SET_COMPILE_FLAG(DEFAULT_Fortran_FLAGS_TESTING "${DEFAULT_Fortran_FLAGS_TESTING}"
                 Fortran  "--coverage" # GNU
                          "/Qcov-gen"  # Intel Windows
                 )

SEPARATE_ARGUMENTS(DEFAULT_Fortran_FLAGS_TESTING)

#####################
### RELEASE FLAGS ###
#####################

# Test with both -02 and -03, as the latter isn't always faster
SET_COMPILE_FLAG(DEFAULT_Fortran_FLAGS_RELEASE "${DEFAULT_Fortran_FLAGS_RELEASE}"
                 Fortran REQUIRED "-O3" # GNU, Intel, Portland Group
                                  "/O3" # Intel Windows
                )

# Unroll loops
SET_COMPILE_FLAG(DEFAULT_Fortran_FLAGS_RELEASE "${DEFAULT_Fortran_FLAGS_RELEASE}"
                 Fortran "-funroll-loops" # GNU
                         "-unroll"        # Intel
                         "/unroll"        # Intel Windows
                         "-Munroll"       # Portland Group
                )

# Inline functions
SET_COMPILE_FLAG(DEFAULT_Fortran_FLAGS_RELEASE "${DEFAULT_Fortran_FLAGS_RELEASE}"
                 Fortran "-inline"            # Intel
                         "/Qinline"           # Intel Windows
                         "-finline-functions" # GNU
                         "-Minline"           # Portland Group
                )

# Interprocedural (link-time) optimizations
SET_COMPILE_FLAG(DEFAULT_Fortran_FLAGS_RELEASE "${DEFAULT_Fortran_FLAGS_RELEASE}"
                 Fortran "-ipo"     # Intel
                         "/Qipo"    # Intel Windows
                         "-flto"    # GNU
                         "-Mipa"    # Portland Group
                )

# Single-file optimizations
SET_COMPILE_FLAG(DEFAULT_Fortran_FLAGS_RELEASE "${DEFAULT_Fortran_FLAGS_RELEASE}"
                 Fortran "-ip"  # Intel
                         "/Qip" # Intel Windows
                )

# Vectorize code
SET_COMPILE_FLAG(DEFAULT_Fortran_FLAGS_RELEASE "${DEFAULT_Fortran_FLAGS_RELEASE}"
                 Fortran "-vec-report0"  # Intel
                         "/Qvec-report0" # Intel Windows
                         "-Mvect"        # Portland Group
                )

SEPARATE_ARGUMENTS(DEFAULT_Fortran_FLAGS_RELEASE)

################################
### CHOOSE APPROPRIATE FLAGS ###
################################
IF(BT STREQUAL "RELEASE")
  message(RELEASE)
  SET(DEFAULT_Fortran_FLAGS ${DEFAULT_Fortran_FLAGS} ${DEFAULT_Fortran_FLAGS_RELEASE})
ELSEIF(BT STREQUAL "DEBUG")
  message(DEBUG)
  SET(DEFAULT_Fortran_FLAGS ${DEFAULT_Fortran_FLAGS} ${DEFAULT_Fortran_FLAGS_DEBUG})
ELSEIF(BT STREQUAL "TESTING")
  message(TESTING)
  SET(DEFAULT_Fortran_FLAGS ${DEFAULT_Fortran_FLAGS} ${DEFAULT_Fortran_FLAGS_TESTING})
ENDIF()

