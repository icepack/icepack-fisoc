# icepack-fisoc

This library contains routines to make the glacier flow modeling library [icepack](https://github.com/icepack/icepack) usable from the Framework for Ice Sheet-Ocean Coupling (FISOC).

#### Build and test

See these [instructions](https://icepack.github.io/installation.html) for how to install icepack and [firedrake](https://www.firedrakeproject.org), the finite element modeling library that icepack is built on.
To use the FISOC wrapper for icepack, you will need to have the firedrake virtual environment activated in your current terminal session first.
The wrapper library is built using CMake:

    mkdir build
    cd build
    cmake ..
    make

To test that everything is working correctly, run

    make test

from the build directory.
