!
! variable_kinds.f90  
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

module variable_kinds
  !* Author:
  !  Date:
  !  License: LGPLv3 or later
  !
  ! Parameters specifying the "kind" of variables needed for different
  ! levels of precision. These will provide the smallest kind of real
  ! or integer compatible with the desired level of precision for your
  ! compiler and hardware. Distinct kinds will be available for all of
  ! these on all hardware. If a kind with the necessary precision is
  ! not available then the parameter value will be negative and any
  ! declarations using it will cause a compiler error.
  !

  integer, parameter :: hp = selected_real_kind(3, 4)
    !! Real kind for half precision
  integer, parameter :: sp = selected_real_kind(7, 38)
    !! Real kind for single precision
  integer, parameter :: dp = selected_real_kind(15, 307)
    !! Real kind for double precision
  integer, parameter :: xp = selected_real_kind(19, 4931)
    !! Real kind for extended precision
  integer, parameter :: qp = selected_real_kind(34, 4931)
    !! Real kind for quad precision
  
  integer, parameter :: i2  = selected_int_kind(2)
    !! Integer kind for values \( \in (-10^2, 10^2) \)
  integer, parameter :: i4  = selected_int_kind(4)
    !! Integer kind for values \( \in (-10^4, 10^4) \)
  integer, parameter :: i9  = selected_int_kind(9)
     !! Integer kind for values \( \in (-10^9, 10^9) \)
  integer, parameter :: i18 = selected_int_kind(18)
    !! Integer kind for values \( \in (-10^18, 10^18) \)
  integer, parameter :: i38 = selected_int_kind(38)
    !! Integer kind for values \( \in (-10^38, 10^38) \)

end module variable_kinds
