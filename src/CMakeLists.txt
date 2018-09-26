
add_library(fisoc_icepack forpy_mod.F90 fisoc_icepack.f90)
target_link_libraries(fisoc_icepack ${PYTHON_LIBRARIES})
