!
! test_program.f90  
! This file is part of PROJECTNAME.
!
! Copyright YEAR AUTHOR <EMAIL> [AUTHOR2 <EMAIL2>, ...]
!  
! This program is free software: you can redistribute it and/or modify
! it under the terms of the GNU Lesser General Public License as
! published by the Free Software Foundation, either version 3 of the
! License, or (at your option) any later version.
!
! This program is distributed in the hope that it will be useful, but
! WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
! Lesser General Public License for more details.
!
! You should have received a copy of the GNU Lesser General Public
! License along with this program.  If not, see
! <https://www.gnu.org/licenses/>.
!

program test
  !! Uses some type/function from the library installed by your
  !! project. If it compiles then that means your library has been
  !! built and installed correctly.
  use type_library
  implicit none
  type(derived_type) :: variable
  variable = derived_type('This message will be printed 3 times.')
end program test
