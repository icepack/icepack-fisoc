FROM icepack/firedrake:buster

RUN sudo apt-get update && sudo apt-get install -yq libnetcdff6 libnetcdff-dev

ENV ESMF_DIR=/home/user/esmf \
    ESMF_COMM=openmpi \
    EMSF_PIO=internal \
    ESMF_F90LINKLIBS="-lmpi_cxx"

RUN git clone https://git.code.sf.net/p/esmf/esmf esmf && \
    cd esmf && \
    git checkout ec966d2e5284f644a069798790045b53f135d2cb && \
    make
