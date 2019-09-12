FROM esmf

# Install icepack
RUN git clone https://github.com/icepack/icepack && \
    cd icepack && \
    git checkout 8ecd1700c6c14dfa0454f54809bee498d6eaa185
RUN cd icepack && pip3 install -e .

# Install gmsh
RUN sudo apt-get install -yq libglu1-mesa libxcursor1 libxinerama1
RUN curl -O http://gmsh.info/bin/Linux/gmsh-4.3.0-Linux64.tgz
RUN tar xvf gmsh-4.3.0-Linux64.tgz && \
    sudo cp gmsh-4.3.0-Linux64/bin/gmsh /usr/bin

# Build and install the icepack Fortran wrapper
RUN git clone --recursive https://github.com/icepack/icepack-fortran && \
    cd icepack-fortran && \
    git checkout f2a5f3605379fb66040dbcf48008aee4b0dc5864
RUN mkdir -p icepack-fortran/build && \
    cd icepack-fortran/build && \
    cmake .. && \
    make && \
    sudo make install

# Copy FISOC into the image
COPY FISOC /home/user/FISOC
RUN sudo chown -R user:user FISOC .[^.]*

ENV ESMFMKFILE=/home/user/esmf/lib/libO/Linux.gfortran.64.mpich3.default/esmf.mk \
    FISOC_DIR=/home/user/FISOC

ENV CPPFLAGS="${CPPFLAGS} -D FISOC_MPI" \
    FFLAGS="${FFLAGS} -fbacktrace -g -O0 -fbounds-check -Wall" \
    FISOC_ISM="icepack" \
    FISOC_ISM_LIBS="-licepack_fortran -lpython3.7m" \
    FISOC_ISM_LIBPATH=/usr/local/lib \
    FISOC_ISM_INCLUDE=/usr/local/include \
    FISOC_ISM_GEOM="FISOC_ISM_MESH" \
    FISOC_AM="dummy" \
    FISOC_AM_LIBS="" \
    FISOC_AM_LIBPATH=/home/user \
    FISOC_AM_INCLUDE=/home/user \
    FISOC_OM="dummy" \
    FISOC_OM_LIBS="" \
    FISOC_OM_INCLUDE=/home/user \
    FISOC_OM_LIBPATH=/home/user \
    FISOC_OM_GEOM="FISOC_OM_GRID"

RUN mkdir bin

RUN cd FISOC && \
    make && \
    make install

COPY icepack-dummy/FISOC_config.rc ./FISOC_config.rc
