# This INCLUDE statement provides a wrapper functions to set up
# pFUnit test suites
INCLUDE(${CMAKE_MODULE_PATH}/pFUnit.cmake)

# Set up to generate coverage reports
FIND_PACKAGE(PythonInterp REQUIRED)
find_program(GCOVR_PATH gcovr PATHS ${CMAKE_SOURCE_DIR}/scripts/test)

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
  add_custom_target(gcovr
    # Create folder
    COMMAND ${CMAKE_COMMAND} -E make_directory ${PROJECT_BINARY_DIR}/gcovr
    
    # Running gcovr
    COMMAND ${Python_EXECUTABLE} ${GCOVR_PATH} --html --html-details -s
            -r ${PROJECT_SOURCE_DIR} --object-directory=${PROJECT_BINARY_DIR}
            -o gcovr/index.html
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "Running gcovr to produce HTML code coverage report."
  )
  # Show info where to find the report
  add_custom_command(TARGET gcovr POST_BUILD
    COMMAND ;
    COMMENT "Open ./gcovr/index.html in your browser to view the full coverage report."
  )
ENDIF()

# Setup up a test project which will check libraries were installed
# properly and the CMake export worked as planned.
CONFIGURE_FILE(test_installation/CMakeLists.txt.in
  test_installation/CMakeLists.txt)
CONFIGURE_FILE(test_installation/test_program.f90
  test_installation/test_program.f90 COPYONLY)
