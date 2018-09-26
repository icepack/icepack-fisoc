
cmake_minimum_required(VERSION 3.0)
project(fisoc_icepack Fortran)

find_package(PythonLibs 3 REQUIRED)
include_directories(${PYTHON_INCLUDE_DIRS})

set(CMAKE_Fortran_MODULE_DIRECTORY ${fisoc_icepack_BINARY_DIR}/include)
add_subdirectory(src)

enable_testing()
add_subdirectory(test)
