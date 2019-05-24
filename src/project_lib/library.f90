!
! library.f90  
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

module library
  !* Author:
  !  Date:
  !  License: LGPLv3 or later
  !
  ! A description of the contents of this module.
  !

  ! Import modules...
  use variable_kinds, only: sp, dp, i4
  implicit none
  private

  ! Variable declarations, type declarations, and procedure interfaces
  real(dp), parameter :: pi = 4._dp * atan(1._dp)
  
  ! Mark public/protected variables, types, and procedures
  public :: a_procedure
  
contains

  ! Function and subroutine definitions

  elemental function a_procedure(x)
    !* Author:
    !  Date:
    !
    ! Documentation for this function stub
    !
    real(dp), intent(in) :: x
      !! An input variable
    real(dp) :: a_procedure
    
    a_procedure = sin(pi*(x - 2._dp))
  end function a_procedure
  
end module library
