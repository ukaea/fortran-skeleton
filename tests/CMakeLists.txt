# This INCLUDE statement provides a wrapper functions to set up
# pFUnit test suites
INCLUDE(${CMAKE_MODULE_PATH}/pFUnit.cmake)

# Add unit tests
FILE(GLOB_RECURSE src_unittest "*.pf")
ADD_PFUNIT_TEST_SUITE(
  unit_tests      # Name of the test suite
  ${src_unittest} # The source files containing the unit tests
  ""              # List of extra Fortran files needed for testing
  ""              # List of extra C/C++ files needed for testing
  )
TARGET_LINK_LIBRARIES(unit_tests
  ${PROJECT_NAME}::${PROJECT_NAME}_lib
  ${PROJECT_NAME}_lib_private # Targets created by ADD_PFUNIT_TEST don't support PUBLIC/PRIVATE dependencies
  ${BUILD_TYPE_Fortran_FLAGS}
)
SET_PROPERTY(TARGET unit_tests PROPERTY
  LINK_FLAGS "${DEBUG_Fortran_FLAGS}")

# Add a simple integration test to the CTest framework
ADD_TEST(NAME executable_test
  COMMAND ${PROJECT_NAME})
SET_TESTS_PROPERTIES(executable_test PROPERTIES
  PASS_REGULAR_EXPRESSION "These are some numbers: *[0-9]\.[0-9]+ *[0-9]\.[0-9]+ *[0-9]+"
  )

# Generate a coverage report for unit tests
IF(CMAKE_BUILD_TYPE STREQUAL "TESTING")
  SETUP_TARGET_FOR_COVERAGE_GCOVR_HTML(
    NAME unit_test_coverage
    EXECUTABLE unit_tests
    EXECUTABLE_ARGS -robust -xml pfunit.xml -name UnitTests
    DEPENDENCIES unit_tests
  )

ENDIF()
