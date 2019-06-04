FIND_PACKAGE("pFUnit" REQUIRED)

# Must use relative paths for source files when passing to ADD_PFUNIT_TEST
FILE(GLOB_RECURSE src_unittest RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} "*.pf")

ENABLE_TESTING()

ADD_PFUNIT_TEST(
  runtests        # Name of the test suite
  ${src_unittest} # The source files containing the unit tests
  ""              # List of extra Fortran files needed for testing
  ""              # List of extra C/C++ files needed for testing
  )

# Targets created by ADD_PFUNIT_TEST don't support PUBLIC/PRIVATE dependencies
TARGET_LINK_LIBRARIES(runtests
  ${PROJECT_NAME}::${PROJECT_NAME}_lib
  ${PROJECT_NAME}_lib_private
)
