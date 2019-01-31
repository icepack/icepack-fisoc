# icepack-fisoc

This library contains routines to make the glacier flow modeling library [icepack](https://github.com/icepack/icepack) usable from the Framework for Ice Sheet-Ocean Coupling (FISOC).


### Contents

This repository has two big parts: a Fortran wrapper library for icepack, and a suite of tools for running coupled ice sheet-ocean models using FISOC inside docker containers.

* `python`: a module called `simulation.py` that wraps the main functionalities of icepack into the bare minimum number of routines necessary for coupled modeling of an ice shelf and the ocean
* `src`: the source code for a Fortran library that wraps all of the functions defined in the `simulation.py` module, and allows reading the values of the ice thickness and other variables from Fortran
* `test`: a Fortran unit test program to check that the wrapper for the python code works
* `dockerfiles`: for building Docker images, which we use to run experiments with FISOC on various machines in a way that the environment appears the same on each

##### Fortran wrapper

See these [instructions](https://icepack.github.io/installation.html) for how to install icepack and [firedrake](https://www.firedrakeproject.org), the finite element modeling library that icepack is built on.
To use the Fortran wrapper for icepack, you will need to have the firedrake virtual environment activated in your current terminal session first.
The wrapper library is built using CMake:

    mkdir build
    cd build
    cmake ..
    make

To test that everything is working correctly, run

    make test

from the build directory.


##### Containerization

To make it easier to run coupled ice sheet-ocean models through FISOC, we have included a set of scripts for building Docker images under the folder `dockerfiles`.
The file `dockerfiles/build.sh` will clone all the necessary dependencies and build docker images for each model configuration we've used.

Build a docker image from a `Dockerfile` in a given directory:

    docker build --tage <username>/<image name>:<image version tag> <directory of Dockerfile>

Start a container interactively so you can run commands at a terminal inside it:

    docker run --interactive --tty <image name> bash

Same as above, but sync a directory on your system with a directory in the container:

    docker run --interactive --tty \
        --volume </path/on/host>:</path/on/container> \
        <image name> bash

The commands to list the docker images and containers on your system are, respectively,

    docker image ls
    docker container ls

By default, these commands will not show intermediate images or stopped containers; you can see these by appending the `--all` flag.
A typical docker image can be 2GB or more, and even stopped containers take up disk space.
The command

    docker system prune

will clean up anything that's obviously unused.
The command to manually remove a docker image is

    docker image rm <image name>:<image version tag>

The prune command won't remove images that you've specifically created yourself by a prior call to `docker build`, so to reclaim space from old images you might have to remove them manually.
