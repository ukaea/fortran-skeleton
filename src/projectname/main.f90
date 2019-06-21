!
! main.f90  
! This file is part of PROJECTNAME.
!
! Copyright YEAR AUTHOR <EMAIL> [AUTHOR2 <EMAIL2>, ...]
!  
! This program is free software: you can redistribute it and/or modify
! it under the terms of the GNU Lesser General Public License as
! published by the Free Software Foundation, either version 3 of the
! License, or (at your option) any later version.
!
! This program is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU Lesser General Public License for more details.
!
! You should have received a copy of the GNU Lesser General Public
! License along with this program.  If not, see
! <https://www.gnu.org/licenses/>.
!

program program_name
  !* Author:
  !  Date:
  !  License: LGPLv3 or later
  !
  ! A description of what your program does.
  !
  
  ! Import modules...
  use variable_kinds, only: sp, dp, i4
  implicit none

  ! Decalare variables...
  real(dp)    :: double_precision_var
  real(sp)    :: single_precision_var
  integer(i4) :: short_var
  
  ! Run your program...
  double_precision_var = 1._dp
  single_precision_var = 2._sp
  short_var = int(real(double_precision_var, sp) + single_precision_var, i4)
  print*, 'These are some numbers: ', double_precision_var, &
       single_precision_var, short_var
end program program_name
