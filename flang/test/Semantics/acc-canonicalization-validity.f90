! RUN: %S/test_errors.sh %s %t %f18 -fopenacc

! Check OpenACC canonalization validity for the construct defined below:
!   2.9 Loop
!   2.11 Parallel Loop
!   2.11 Kernels Loop
!   2.11 Serial Loop

program openacc_clause_validity

  implicit none

  integer :: i, j
  integer :: N = 256
  real(8) :: a(256)

  !ERROR: A DO loop must follow the LOOP directive
  !$acc loop
  i = 1

  !ERROR: DO loop after the LOOP directive must have loop control
  !$acc loop
  do
  end do

  !ERROR: A DO loop must follow the PARALLEL LOOP directive
  !$acc parallel loop
  i = 1

  !ERROR: A DO loop must follow the KERNELS LOOP directive
  !$acc kernels loop
  i = 1

  !ERROR: A DO loop must follow the SERIAL LOOP directive
  !$acc serial loop
  i = 1

  !ERROR: The END PARALLEL LOOP directive must follow the DO loop associated with the loop construct
  !$acc end parallel loop

  !ERROR: The END KERNELS LOOP directive must follow the DO loop associated with the loop construct
  !$acc end kernels loop

  !ERROR: The END SERIAL LOOP directive must follow the DO loop associated with the loop construct
  !$acc end serial loop

  !$acc parallel loop
  do i = 1, N
    a(i) = 3.14
  end do

  !$acc kernels loop
  do i = 1, N
    a(i) = 3.14
  end do

  !$acc serial loop
  do i = 1, N
    a(i) = 3.14
  end do

  !$acc parallel loop
  do i = 1, N
    a(i) = 3.14
  end do
  !$acc end parallel loop

  !$acc kernels loop
  do i = 1, N
    a(i) = 3.14
  end do
  !$acc end kernels loop

  !$acc serial loop
  do i = 1, N
    a(i) = 3.14
  end do
  !$acc end serial loop

  !ERROR: DO loop after the PARALLEL LOOP directive must have loop control
  !$acc parallel loop
  do
  end do

  !ERROR: DO loop after the KERNELS LOOP directive must have loop control
  !$acc kernels loop
  do
  end do

  !ERROR: DO loop after the SERIAL LOOP directive must have loop control
  !$acc serial loop
  do
  end do

end program openacc_clause_validity
