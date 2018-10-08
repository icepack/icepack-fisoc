program wrapper_test

use :: fisoc_icepack, only: simulation
use :: iso_c_binding, only: c_char
use :: iso_fortran_env, only: real64

implicit none

    ! Command-line arguments
    integer :: num_cmdline_args
    character(len=256, kind=c_char) :: cmdline_arg

    ! Simulation object and pointers to field data
    type(simulation) :: s
    real(kind=real64), dimension(:,:), pointer :: velocity
    real(kind=real64), dimension(:), pointer :: thickness, accumulation, melt

    num_cmdline_args = command_argument_count()
    if (num_cmdline_args /= 1) call exit(1)
    call get_command_argument(1, cmdline_arg)

    call s%initialize(cmdline_arg)

    call s%get_velocity(velocity)
    write(*, *) size(velocity, 1), size(velocity, 2)
    write(*, *) velocity(1, 1), velocity(2, 1)

    call s%get_thickness(thickness)
    write(*, *) size(thickness)
    write(*, *) thickness(1)

    call s%diagnostic_solve

    write(*, *) velocity(1, 1), velocity(2, 1)

    call s%get_accumulation_rate(accumulation)
    call s%get_melt_rate(melt)

    write(*, *) accumulation(1), melt(1)

    call s%destroy

end program
