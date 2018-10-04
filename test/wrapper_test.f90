program wrapper_test

    use :: forpy_mod, only: forpy_initialize, forpy_finalize, module_py, object
    use :: fisoc_icepack, only: get_simulation_module, simulation_initialize, &
        simulation_get_velocity_data, simulation_get_thickness_data
    use :: iso_c_binding, only: c_char
    use :: iso_fortran_env, only: real64
    implicit none

    ! for command-line arguments
    integer :: num_cmdline_args
    character(len=256, kind=c_char) :: cmdline_arg

    integer :: ierror
    type(module_py) :: simulation
    type(object) :: state
    real(kind=real64), dimension(:,:), pointer :: velocity_data
    real(kind=real64), dimension(:), pointer :: thickness_data

    num_cmdline_args = command_argument_count()
    if (num_cmdline_args /= 1) call exit(1)
    call get_command_argument(1, cmdline_arg)

    ierror = forpy_initialize()

    call get_simulation_module(simulation)
    call simulation_initialize(simulation, trim(cmdline_arg), state)

    call simulation_get_velocity_data(simulation, state, velocity_data)
    write(*, *) size(velocity_data, 1), size(velocity_data, 2)
    write(*, *) velocity_data(1, 1), velocity_data(2, 1)

    call simulation_get_thickness_data(simulation, state, thickness_data)
    write(*, *) size(thickness_data)
    write(*, *) thickness_data(1)

    call state%destroy
    call simulation%destroy

    call forpy_finalize

end program
