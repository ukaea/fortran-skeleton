!
! type_library.f90  
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

module type_library
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
  type :: derived_type
     !* Author:
     !  Date:
     !
     ! Documentation for this derived type
     !
     private
     ! Components of the derived type
   contains
     ! Type-bound procedures (i.e., methods)
  end type derived_type

  interface derived_type
     !! Routines with which to build instances of [derived_type(type)].
     module procedure :: constructor
  end interface derived_type
  
  ! Mark public/protected variables, types, and procedures
  public :: derived_type
    
contains

  ! Function and subroutine definitions/method implementations
  function constructor(input)
    !* Author:
    !  Date:
    !
    ! A function to build objects of yoru derived type, setting the
    ! private components.
    !
    character(len=*), intent(in) :: input
      !! Some variable used to build objects of your derived type
    type(derived_type)           :: constructor
  end function constructor
  
end module type_library
