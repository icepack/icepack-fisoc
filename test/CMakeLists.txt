add_executable(wrapper_test wrapper_test.f90)
target_link_libraries(wrapper_test fisoc_icepack)
add_test(wrapper_test wrapper_test ${fisoc_icepack_SOURCE_DIR}/test/config.json)
set_tests_properties(wrapper_test PROPERTIES ENVIRONMENT
                     "PYTHONPATH=${fisoc_icepack_SOURCE_DIR}/python/")
