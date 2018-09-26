
program wrapper_test

    use :: forpy_mod
    use :: fisoc_icepack, only: set_argv
    implicit none

    integer :: ierror
    type(module_py) :: simulation

    ierror = forpy_initialize()

    call set_argv

    ierror = import_py(simulation, "simulation")
    ierror = call_py_noret(simulation, "run_simulation")

    call simulation%destroy

    call forpy_finalize

end program
