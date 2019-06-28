# Fortran Project Skeleton

[![pipeline status](https://git.ccfe.ac.uk/soft-eng-group/rse/skeleton-repositories/fortran/badges/master/pipeline.svg)](https://git.ccfe.ac.uk/soft-eng-group/rse/skeleton-repositories/fortran/pipelines)
[![Unit test coverage](https://git.ccfe.ac.uk/soft-eng-group/rse/skeleton-repositories/fortran/badges/master/coverage.svg?job=unit_tests)](http://cmacmack.gitpages.ccfe.ac.uk/fortran/unit_coverage/)
[![All test coverage](https://git.ccfe.ac.uk/soft-eng-group/rse/skeleton-repositories/fortran/badges/master/coverage.svg?job=all_tests)](http://cmacmack.gitpages.ccfe.ac.uk/fortran/all_coverage/)
[![Documentation](https://img.shields.io/badge/docs-FORD-steelblue.svg)](http://cmacmack.gitpages.ccfe.ac.uk/fortran/)

This repository provides the skeleton of a Fortran project. It can be
used as a template when beginning a new piece of Fortran software.


## Adapting this Repository

To use this template, run the following commands:
```
git clone https://git.ccfe.ac.uk/soft-eng-group/rse/skeleton-repositories/fortran.git PROJECTNAME
cd PROJECTNAME
rm -Rf .git/
git init
```
This will download the files onto your computer and create a new git
repository. You will also need to install the following software
(needed during the build and testing process) on your computer:
[gfortran](https://gcc.gnu.org/wiki/GFortran), [cmake](https://cmake.org), [graphviz](https://www.graphviz.org/), [FORD](https://github.com/Fortran-FOSS-Programmers/ford), and [gcovr](https://www.gcovr.com/en/stable/#). On Ubuntu this can be
achieved by running
```
sudo apt-get install python-pip gfortran cmake graphviz gcovr
sudo pip install ford
```
Finally, you will need to build the
[pFUnit](http://pfunit.sourceforge.net/) framework on your computer so
you can run unit tests. This should be done using CMake, adapting
installation directory and other configurations as necessary:
```
pfdir=$HOME/.pfunit
wget https://downloads.sourceforge.net/project/pfunit/Source/pFUnit-3.2.9.tgz
tar xvf pFUnit-3.2.9.tgz
mkdir pFUnit-3.2.9/build
cd pFUnit-3.2.9/build
cmake -DMPI=NO -DOPENMP=NO -DCMAKE_INSTALL_PREFIX=$pfdir -DINSTALL_PATH=$pfdir ..
make
make install
echo "export CMAKE_PREFIX_PATH=$pfdir:$CMAKE_PREFIX_PATH" >> $HOME/.bashrc
. $HOME/.bashrc
```

You should then do the following to customise your new project:

1. Change the copyright header in each file, specifying the project
   name, the names of the authors, and the year(s) of releases.
2. Edit [LICENSE.md](LICENSE.md) and file headers to contain your
   preferred [software license](#license).
3. Edit [CONTRIBUTING.md](CONTRIBUTING.md) to explain the workflow for
   your project, along with any other information which would be
   needed by new developers.
4. Change source file names/directory structure according to your needs.
4. Edit the various CMakeLists.txt files according to how you wish to
   structure the libraries and/or executables in your project.
5. Change the compiler flags specified in
   [SetFortranFlags.cmake](cmake/Modules/SetFortranFlags.cmake) to
   meet your needs.
6. If using MPI, configure cmake to use the appropriate compiler
   wrappers.
7. Edit the contents of [ford-docs.md](ford-docs.md) and the
   [doc-pages](doc-pages) directory to provide documentation for your
   project.
8. Replace the contents of this README with a description of your own project.
9. Commit your changes and push your new repository to GitLab.
10. Set up various configurations in the GitLab and consider making a
    wiki. Under Settings > CI/CD > General pipelines > Test coverage
    parsing, specify the regular expression `^lines: (\d+.\d+)%`.
11. Set badges for your project under Settings > General > Badges,
    using the ones in this README as an example.


## CMake Build

Some basic configurations for [CMake](https://cmake.org) are
provided. These are (heavily) adapted from the template provided by
[Seth Morton on
GitHub](https://github.com/SethMMorton/cmake_fortran_template). The
build system was refactored to comply with [modern CMake best
practice](https://pabloariasal.github.io/2018/02/19/its-time-to-do-cmake-right/),
adapted slightly to account for differences between Fortran and C++.

In particular, Fortran presents the challenge of indicating which
modules in a library should be publicly accessible to an end user and
which should be for internal use only. This was achieved by making the
private modules part of a separate target from the overall
library. This target was a static library which was then used as a
private dependency by the main (publicly accessible) library. This
ensured that CMake would keep the public and private module interfaces
separate and not expose the latter to the end user. See
[src/project_lib/CMakeLists.txt](src/project_lib/CMakeLists.txt).

The basic approach to building with CMake is as follows:
```
mkdir build; cd build
cmake ..
make
make install # If desired
```

Configurations can be specified as arguments to the `cmake`
command. In particular, you can specify `-DCMAKE_BUILD_TYPE=<VALUE>`
where value can be `DEBUG`, `TESTING`, or `RELEASE`, with each one
changing compiler flags to be most suitable to the given use
case. `DEBUG` builds will not be optimised, provides debugger symbols,
and performs additional run-time checks. `TESTING` builds are not
optimised and have debugger symbols, but does not perform run-time
checks. Additionally, the binaries are instrumented to emit coverage
information describing which lines of source files have been
executed. Finally `RELEASE` provides full optimisation (it is worth
experimenting with these settings, as the most aggressive optimisation
is not always the fastest) and does not offer any run-time checks,
debugger information, or instrumentation. If you wish to install to a
non-standard location, you can specify
`-DCMAKE_INSTALL_PREFIX=<INSTALL-LOCATION>` when invoking CMake.


## Testing and Test Coverage

An example of using pFUnit for unit testing is provided in the
[tests](tests/) directory. pFUnit files (ending in .pf) are Fortran
files with a [few additional
directives](http://pfunit.sourceforge.net/page_pFUnitParser.html)
included to indicate which routines implement tests and to provide
assertion testing. These are preprocessed before being passed to a
Fortran compiler. All of this is handled by the CMake configurations
in this directory; all you need to do is create additional files
ending in `.pf` and specify in
[tests/CMakeLists.txt](tests/CMakeLists.txt) any libraries which your
tests will need to link against. The tests will then automatically be
built when invoking `make all`.

The tests can then either be run directly by executing
`tests/unit_tests` from within the build directory or by running
`ctest` from there. The latter will also run any additional tests
which you have [configured in your
CMakeLists.txt](https://gitlab.kitware.com/cmake/community/wikis/doc/ctest/Testing-With-CTest)
files. As an example, a simple integration test called
`executable_test` was configured here. This simply runs the executable
produced when building this project and checking the format of the
output.

You should write unit tests which cover as much of your code as
possible (ideally approaching 100%). The [gcovr
tool](https://www.gcovr.com/en/stable/) can be used to analyse this,
providing both an overall coverage percentage and a line-by-line
report. CMake has been configured to handle any tricky details
involved in this. To generate coverage reports for your unit tests,
run `make unit_test_coverage` from withing the build directory.


## Documentation

If it is to be useful to anyone else, you must document your
code. Broadly speaking, you can consider three types of documentation:

- detailed comments within your code explaining the algorithm 
  and implementation details
- API documentation describing the derived types, functions, 
  subroutines, etc. within your code
- tutorials on installing and using the software

The first of these is a matter of programming style and you
should provide clear guidelines to developers on how to do this.

While it is possible to manually write API documentation, this is
tedious and has the potential to become out of sync with your code. It
is generally considered that the best approach is to use an [automatic
documentation
generator](https://en.wikipedia.org/wiki/Documentation_generator). Such
a tool will analyse your source code to determine the API and extract
specially-formatted comments explaining the purpose of each derived
type, function, etc. The best and most comprehensive such tool for
Fortran is [FORD](https://github.com/Fortran-FOSS-Programmers/ford)
and all example source files within this project contain comments
readable by FORD. You should add these to your own code as you write
it. This ensures that both users and developers will understand its
purpose. FORD reads its configurations, plus an overall description of
the code, from a _project file_, in this case called
[ford-docs.md](ford-docs.md). CMake has been configured to be able to
build the documentation for you. Simply run `make docs` in the build
directory. As [described below](#continuous-integration), this project
is configured so that GitLab's continuous integration service will
generate and deploy this documentation ([see an example
here](http://cmacmack.gitpages.ccfe.ac.uk/fortran/)).

You should write tutorials explaining how to use your software as
well. Depending on the software in question it may also be useful to
provide information on the physics and/or numerical methods
involved. It can also be helpful to developers to provide a high-level
overview of how the code is structured. This documentation could be
provided in your project's [GitLab
wiki](https://docs.gitlab.com/ee/user/project/wiki/) or as [pages
within your FORD
documentation](https://github.com/Fortran-FOSS-Programmers/ford/wiki/Writing-Pages).
A template for these sorts of pages is provided in the
[doc-pages](doc-pages/) directory.


## Continuous Integration

GitLab offers a [Continuous
Integration](https://git.ccfe.ac.uk/help/ci/README.md) service which
can automatically build, test, and deploy your software. The results of
trying to build and test your software are then displayed in the
GitLab interface for each branch and merge request. The settings for
this are provided in the [.gitlab-ci.yml](.gitlab-ci.yml) file. In
this project, the CI configurations do the following:

- compile your code
- try to build API documentation
- run unit tests and produce coverage reports
- run any other tests
- check that cmake has been configured to install the project correctly
- if on the `master` branch, deploy documentation and code coverage to [GitLab pages](https://git.ccfe.ac.uk/help/user/project/pages/index.md)

These configurations mostly rely on CMake to do the hard work and
therefore shouldn't need to be edited very often. However, it may be
necessary to, e.g., install any third-party libraries which your
project depends on. This can be done withing the configuration scripts
or by [creating a custom docker
image](https://git.ccfe.ac.uk/soft-eng-group/rse/continuous-integration/custom-docker-image)
to use when running the CI. Currently, a [docker
image](https://cloud.docker.com/u/cmacmackin/repository/docker/cmacmackin/fortran-env)
is used which provide all of the tools necessary to build and test
this project, plus some commonly used libraries such as MPICH, BLAS,
and LAPACK.

Unfortunately, the current version of GitLab is not able to host pages
for projects within sub-groups, such as this one. As such, the
automatic deployment and hosting of documentation and code coverage
reports can not be easily demonstrated. See a [fork of this
repository] for a demonstration of this feature in action for
[documentation](http://cmacmack.gitpages.ccfe.ac.uk/fortran/), [unit
test
coverage](http://cmacmack.gitpages.ccfe.ac.uk/fortran/unit_coverage/),
and [coverage for all
tests](http://cmacmack.gitpages.ccfe.ac.uk/fortran/all_coverage/).


## License

UKAEA does not currently have a policy on what licence your code
should be released under. However, the GNU Lesser General Public
License (LGPL) is a good choice. This allows anyone to use and modify
your software providing the derivatives are similarly
licensed. However, unlike the stronger GNU General Public License
(GPL), it still allows unmodified libraries to be used by proprietary
or otherwise differently licensed software. For more on the different
free and open source software licenses available, see
[choosealicense.com](https://choosealicense.com/licenses/).

The texts of the LGPL and GPL (version 3) are included in this
template and should not be deleted if you wish to use this
license. Notifications of licensing are provided at the top of all
example source files. See the [GNU project for more
details](https://www.gnu.org/licenses/gpl-howto.html) on using their
licenses. __However, the inclusion of (L)GPL documents in this
repository is for the purposes of a providing an example only. The
repository itself is not licensed under the LGPL.__ It is licensed
under the [CC0
1.0](https://creativecommons.org/publicdomain/zero/1.0/), meaning it
is effectively public domain.
