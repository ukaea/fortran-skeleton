INCLUDE(EXTERNALPROJECT)

SET(PFUNIT_PREFIX pfunit-prefix)
EXTERNALPROJECT_ADD(
  pFUnit
  PREFIX ${PFUNIT_PREFIX}
  URL https://downloads.sourceforge.net/project/pfunit/Source/pFUnit-3.2.9.tgz
  URL_MD5 577743103a97f05b52f1cbc31845a123
  UPDATE_COMMAND ""
  CMAKE_ARGS "-DMPI=NO -DOPENMP=NO -DCMAKE_INSTALL_PREFIX=${PFUNIT_PREFIX} 
              -DINSTALL_PATH=${PFUNIT_PREFIX}"
  )
EXTERNALPROJECT_GET_PROPERTY(pFUnit pfunit_install)
INCLUDE(${pfunit_install}/pFUnitConfig.cmake)

FILE(GLOB_RECURSE src_unittest "*.pf")
ENABLE_TESTING()

ADD_PFUNIT_TEST(
  ${TESTS_EXE}    # Name of the test suite
  ${src_unittest} # The source files containing the unit tests
  ""              # List of extra Fortran files needed for testing
  ""              # List of extra C/C++ files needed for testing
  )
TARGET_LINK_LIBRARIES(${TESTS_EXE} ${PROJECT_LIB})
