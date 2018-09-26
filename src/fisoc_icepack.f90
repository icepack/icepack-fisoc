
module fisoc_icepack

    use :: forpy_mod
    implicit none

contains

subroutine set_argv
    integer :: ierror
    type(module_py) :: sys
    type(list) :: empty_list

    ierror = import_py(sys, "sys")
    ierror = list_create(empty_list)
    ierror = sys%setattr("argv", empty_list)

    call empty_list%destroy
    call sys%destroy
end subroutine

end module fisoc_icepack
