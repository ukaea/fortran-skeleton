# Provides a wrapper for the add_pfunit_test function provided in the
# pFUnit cmake config file.

FIND_PACKAGE("pFUnit" REQUIRED)

# Function     : add_pfunit_testsuite
#
# Description : Wrapper for the pFUnit-provided helper function for
#                compiling and adding pFUnit tests to the CTest
#                testing framework. Any libraries needed in testing
#                should be linked to manually. The wrapper converts
#                any absolute paths to .pf files to relative ones
#                (requried for the build to work) and ensures that the
#                test suite is built so it can run robustly.
#
#                IMPORTANT! This function will only work if the test
#                source filename is the same as the module inside it!
#                For example, the file testSomething.pf should contain
#                the module testSomething.
#
# Arguments    : - test_package_name: Name of the test package
#                - test_sources     : List of pf-files to be compiled
#                - extra_sources    : List of extra Fortran source code
#                                     used for testing (if none, input
#                                     empty string "")
#                - extra_sources    : List of extra C/C++ source code used
#                                     for testing (if none, input empty
#                                     string "")
#
# Example usage: enable_testing()
#                set (TEST_SOURCES
#                   testMyLib.pf
#                    )
#                add_pfunit_test (myTests "${TEST_SOURCES} "" "")
#                target_link_libraries (myTests myLibrary) #Assuming "myLibrary" is already defined
#                
#                Compile the tests:   make myTests
#                Run the tests with CTest: ctest -R myTests --verbose
function (add_pfunit_test_suite test_package_name test_sources extra_sources extra_sources_c)
  # add_pfunit_test expects relative paths to .pf files, so convert any absolute paths
  set(sources_rel "")
  foreach(f ${test_sources})
    file(RELATIVE_PATH relf ${CMAKE_CURRENT_SOURCE_DIR} ${f})
    list(APPEND sources_rel ${relf})
  endforeach()

  add_pfunit_test(${test_package_name} ${sources_rel} "${extra_sources}" "${extra_sources_c}")

  target_compile_definitions(${test_package_name} PRIVATE -DBUILD_ROBUST)
endfunction()
