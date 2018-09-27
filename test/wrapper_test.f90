
program wrapper_test

    use :: forpy_mod
    use :: fisoc_icepack, only: set_argv
    use :: iso_fortran_env, only: real64
    implicit none

    integer :: ierror
    type(module_py) :: simulation
    type(object) :: fields, velocity, thickness
    type(object) :: velocity_data_object
    type(ndarray) :: velocity_data_ndarray
    type(tuple) :: args
    real(kind=real64), dimension(:,:), pointer :: velocity_data

    ierror = forpy_initialize()

    call set_argv

    ierror = import_py(simulation, "simulation")
    ierror = call_py(fields, simulation, "init")
    if (is_none(fields)) then
        call exit(1)
    endif

    ierror = fields%getattribute(velocity, "velocity")
    if (is_none(velocity)) then
        stop
    endif

    ierror = fields%getattribute(thickness, "thickness")
    if (is_none(thickness)) then
        stop
    endif

    ierror = tuple_create(args, 1)
    if (ierror /= 0) then
        stop
    endif
    ierror = args%setitem(0, fields)
    if (ierror /= 0) then
        stop
    endif
    ierror = call_py(fields, simulation, "run", args)
    if (ierror /= 0) then
        stop
    endif

    ierror = call_py(velocity_data_object, simulation, "get_velocity", args)
    if (ierror /= 0) then
        call err_print
        stop
    endif
    ierror = cast(velocity_data_ndarray, velocity_data_object)
    if (ierror /= 0) then
        call err_print
        stop
    endif
    ierror = velocity_data_ndarray%get_data(velocity_data, 'C')
    if (ierror /= 0) then
        call err_print
        stop
    endif
    write(*, *) size(velocity_data, 1), size(velocity_data, 2)
    write(*, *) velocity_data(1, 1), velocity_data(2, 1)

    call simulation%destroy
    call fields%destroy

    call forpy_finalize

end program
