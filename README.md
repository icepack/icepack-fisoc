# icepack-fisoc

This repo is for making the glacier flow modeling library [icepack](https://github.com/icepack/icepack) usable from the Framework for Ice Sheet-Ocean Coupling (FISOC).
The repo consists of a set of dockerfiles and FISOC configuration scripts that enable running experiments with FISOC on any machine in a way that the environment appears the same on each.

The scripts for building these Docker images are under the folder `dockerfiles`.
The file `dockerfiles/build.sh` will clone all the necessary dependencies and build docker images for each model configuration we've used.

### Docker cheatsheet

Build a docker image from a `Dockerfile` in a given directory:

    docker build --tag <username>/<image name>:<image version tag> <directory of Dockerfile>

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
