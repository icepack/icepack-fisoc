
#define check_error(ierror) if (ierror /= 0) then; call err_print; stop; endif

module fisoc_icepack

    use :: forpy_mod
    use :: iso_fortran_env, only: real64
    implicit none

contains

subroutine set_argv
    integer :: ierror
    type(module_py) :: sys
    type(list) :: empty_list

    check_error(import_py(sys, "sys"))
    check_error(list_create(empty_list))
    check_error(sys%setattr("argv", empty_list))

    call empty_list%destroy
    call sys%destroy
end subroutine


subroutine get_simulation_module(simulation)
    type(module_py), intent(out) :: simulation

    call set_argv
    check_error(import_py(simulation, "simulation"))
end subroutine


subroutine simulation_initialize(simulation, state)
    type(module_py), intent(in) :: simulation
    type(object), intent(out) :: state

    check_error(call_py(state, simulation, "init"))
end subroutine


subroutine simulation_get_velocity_data(simulation, state, velocity_data)
    type(module_py), intent(in) :: simulation
    type(object), intent(in) :: state
    real(kind=real64), dimension(:,:), pointer, intent(out) :: velocity_data

    ! local variables
    type(tuple) :: args
    type(object) :: velocity_object
    type(ndarray) :: velocity_ndarray

    check_error(tuple_create(args, 1))
    check_error(args%setitem(0, state))
    check_error(call_py(velocity_object, simulation, "get_velocity", args))
    check_error(cast(velocity_ndarray, velocity_object))
    check_error(velocity_ndarray%get_data(velocity_data, 'C'))
end subroutine


subroutine simulation_get_thickness_data(simulation, state, thickness_data)
    type(module_py), intent(in) :: simulation
    type(object), intent(in) :: state
    real(kind=real64), dimension(:), pointer, intent(out) :: thickness_data

    ! local variables
    type(tuple) :: args
    type(object) :: thickness_object
    type(ndarray) :: thickness_ndarray

    check_error(tuple_create(args, 1))
    check_error(args%setitem(0, state))
    check_error(call_py(thickness_object, simulation, "get_thickness", args))
    check_error(cast(thickness_ndarray, thickness_object))
    check_error(thickness_ndarray%get_data(thickness_data, 'C'))
end subroutine


end module
