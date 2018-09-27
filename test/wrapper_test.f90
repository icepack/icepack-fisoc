program wrapper_test

    use :: forpy_mod, only: forpy_initialize, forpy_finalize, module_py, object
    use :: fisoc_icepack, only: get_simulation_module, simulation_initialize, &
        simulation_get_velocity_data
    use :: iso_fortran_env, only: real64
    implicit none

    integer :: ierror
    type(module_py) :: simulation
    type(object) :: state
    real(kind=real64), dimension(:,:), pointer :: velocity_data

    ierror = forpy_initialize()

    call get_simulation_module(simulation)
    call simulation_initialize(simulation, state)
    call simulation_get_velocity_data(simulation, state, velocity_data)

    write(*, *) size(velocity_data, 1), size(velocity_data, 2)
    write(*, *) velocity_data(1, 1), velocity_data(2, 1)

    call state%destroy
    call simulation%destroy

    call forpy_finalize

end program
