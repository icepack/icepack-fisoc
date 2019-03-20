FROM esmf

# Copy elmer into the container image
COPY elmerfem /home/user/elmerfem
RUN sudo chown -R user:user elmerfem .[^.]*

# Copy FISOC into the container image
COPY FISOC /home/user/FISOC
RUN sudo chown -R user:user FISOC .[^.]*

# Copy ROMS into the container image
COPY ROMSIceShelf /home/user/ROMSIceShelf
RUN sudo chown -R user:user ROMSIceShelf .[^.]*

# Build elmer dependencies
RUN sudo apt-get update && sudo apt-get install -yq libmetis-dev libmumps-dev
RUN wget http://glaros.dtc.umn.edu/gkhome/fetch/sw/parmetis/parmetis-4.0.3.tar.gz && \
    tar xvf parmetis-4.0.3.tar.gz && \
    cd parmetis-4.0.3 && \
    make config && \
    sudo make install

# Build elmer
# NOTE: Building in debug mode while testing, remove later
ENV ELMER_HOME=/usr/local
RUN mkdir -p elmerfem/build && \
    cd elmerfem/build && \
    cmake -DCMAKE_INSTALL_PREFIX="${ELMER_HOME}" \
          -DCMAKE_Fortran_COMPILER_SUPPORTS_CONTIGUOUS=FALSE \
          -DCMAKE_BUILD_TYPE=Debug \
          -DWITH_MPI=True \
          -DWITH_Mumps=True \
          -DWITH_ElmerIce=True \
          .. && \
    make && \
    sudo make install

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

# Build FISOC
ENV ESMFMKFILE=/home/user/esmf/lib/libO/Linux.gfortran.64.openmpi.default/esmf.mk \
    FISOC_DIR=/home/user/FISOC

ENV CPPFLAGS="${CPPFLAGS} -D FISOC_MPI -D ROMS_DSDT -D ROMS_DDDT" \
    FFLAGS="${FFLAGS} -fbacktrace -g -O0 -fbounds-check -Wall" \
    FISOC_MPI="yes" \
    FISOC_ISM="Elmer" \
    FISOC_ISM_INCLUDE="${ELMER_HOME}/share/elmersolver/include" \
    FISOC_ISM_LIBPATH="${ELMER_HOME}/lib/elmersolver" \
    FISOC_ISM_LIBS="-lelmersolver" \
    FISOC_AM="dummy" \
    FISOC_AM_LIBS="" \
    FISOC_AM_LIBPATH=/home/user \
    FISOC_AM_INCLUDE=/home/user \
    FISOC_OM="ROMS" \
    FISOC_OM_LIBS="-loceanM" \
    FISOC_OM_INCLUDE="${MY_ROMS_DIR}/Build" \
    FISOC_OM_LIBPATH="${LIBDIR}" \
    FISOC_OM_GEOM="FISOC_OM_GRID"

ENV LD_LIBRARY_PATH="${ELMER_HOME}/lib/elmersolver:${ELMER_HOME}/share/elmersolver/lib:${FISOC_OM_LIBPATH}:${LD_LIBRARY_PATH}"

RUN mkdir bin
RUN cd FISOC && make && make install

COPY elmer-roms/FISOC_config.rc ./FISOC_config.rc
COPY FISOC/examples/Ex5_BensBox_gl/FISOC_Ex5b.sif ./FISOC_Ex5b.sif
COPY elmer-roms/ocean_iceshelf2d_toy_gl.in ./ocean_iceshelf2d_toy_gl.in
RUN sudo chown -R user:user ./ocean_iceshelf2d_toy_gl.in

COPY FISOC/examples/Ex5_BensBox_gl/FISOC_Ex5.grd ./FISOC_Ex5.grd
RUN ElmerGrid 1 2 FISOC_Ex5.grid && \
    ElmerGrid 2 2 FISOC_Ex5 -partition 1 4 0 2

COPY FISOC/examples/Ex1_LongThinMIS/FISOC_Elmer_geometries.f90 ./FISOC_Elmer_geometries.f90
RUN elmerf90 FISOC_Elmer_geometries.f90 -o FISOC_Elmer_geometries.so && \
    sudo mv FISOC_Elmer_geometries.so "${ELMER_HOME}/share/elmersolver/lib/"
