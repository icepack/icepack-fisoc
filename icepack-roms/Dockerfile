FROM esmf

# Copy ROMS into the container image
COPY ROMSIceShelf /home/user/ROMSIceShelf
RUN sudo chown -R user:user ROMSIceShelf .[^.]*

# Build ROMS
ENV ROMS_APPLICATION=ICESHELF2D_TOY_GL
ENV MY_ROMS_DIR=/home/user/ROMSIceShelf
ENV COMPILER=${MY_ROMS_DIR}/Compilers \
    MAKE_SHAREDLIB=on \
    LIBDIR=${MY_ROMS_DIR}/Lib/FISOC \
    MY_CPP_FLAGS=" -DFISOC -DSDT -DDDT" \
    USE_MPI=on \
    USE_MPIF90=on \
    which_MPI=openmpi \
    FORT=gfortran \
    USE_LARGE=on \
    USE_NETCDF4=on \
    USE_MY_LIBS=on \
    MY_HEADER_DIR=${MY_ROMS_DIR}/ROMS/Include \
    MY_ANALYTICAL_DIR=${MY_ROMS_DIR}/ROMS/Functionals \
    BINDIR=${MY_ROMS_DIR}/install \
    SCRATCH_DIR=${MY_ROMS_DIR}/Build \
    NETCDF_INCDIR=/usr/include \
    NETCDF_LIBDIR=/usr/lib/x86_64-linux-gnu \
    NC_CONFIG=/usr/bin/nf-config

RUN mkdir -p ${LIBDIR} && \
    mkdir -p ${BINDIR} && \
    cd ROMSIceShelf && make

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
    git checkout 658202195eb9d482b12c901d10c55223ffffd201
RUN mkdir -p icepack-fortran/build && \
    cd icepack-fortran/build && \
    cmake .. && \
    make && \
    sudo make install

# Create the initial data for the glacier model
COPY icepack-roms/make_ism_input_data.py /home/user/make_ism_input_data.py
RUN python3 make_ism_input_data.py

# Copy FISOC into the image
COPY FISOC /home/user/FISOC
RUN sudo chown -R user:user FISOC .[^.]*

# Set environment variables and build FISOC
ENV ESMFMKFILE=/home/user/esmf/lib/libO/Linux.gfortran.64.openmpi.default/esmf.mk \
    FISOC_DIR=/home/user/FISOC

ENV CPPFLAGS="${CPPFLAGS} -D FISOC_MPI -D ROMS_DSDT -D ROMS_DDDT" \
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
    FISOC_OM="ROMS" \
    FISOC_OM_LIBS="-loceanM" \
    FISOC_OM_INCLUDE="${MY_ROMS_DIR}/Build" \
    FISOC_OM_LIBPATH="${LIBDIR}" \
    FISOC_OM_GEOM="FISOC_OM_GRID"

RUN mkdir bin
RUN cd FISOC && \
    make && \
    make install

# Copy the domain outline into the container and generate a mesh
COPY FISOC/examples/Ex5_BensBox_gl/FISOC_Ex5_RM.geo ./domain.geo
RUN gmsh -2 -format msh2 domain.geo

# Copy the icepack config into the container and generate initial data
COPY icepack-roms/icepack-config.json ./icepack-config.json

# Copy the ROMS .in file into the container
COPY icepack-roms/ocean_iceshelf2d_toy_gl.in ./ocean_iceshelf2d_toy_gl.in
RUN sudo chown -R user:user ./ocean_iceshelf2d_toy_gl.in

# Copy the FISOC config file into the container
COPY icepack-roms/FISOC_config.rc ./FISOC_config.rc
