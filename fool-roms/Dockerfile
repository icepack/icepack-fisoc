FROM esmf

# Copy FISOC into the container image
COPY FISOC /home/user/FISOC
RUN sudo chown -R user:user FISOC .[^.]*

# Copy ROMS into the container image
COPY ROMSIceShelf /home/user/ROMSIceShelf
RUN sudo chown -R user:user ROMSIceShelf .[^.]*

# Build ROMS
ENV ROMS_APPLICATION=ISOMIP_PLUS
ENV MY_ROMS_DIR=/home/user/ROMSIceShelf
ENV COMPILER=${MY_ROMS_DIR}/Compilers \
    MAKE_SHAREDLIB=on \
    LIBDIR=${MY_ROMS_DIR}/Lib/FISOC \
    MY_CPP_FLAGS=" -DFISOC -DMASKING -DDDT" \
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

ENV CPPFLAGS="${CPPFLAGS} -D FISOC_MPI -D ROMS_MASKING -D ROMS_DDDT" \
    FFLAGS="${FFLAGS} -fbacktrace -g -O0 -fbounds-check -Wall" \
    FISOC_MPI="yes" \
    FISOC_ISM="dummy" \
    FISOC_ISM_LIBS="" \
    FISOC_ISM_LIBPATH=/home/user \
    FISOC_ISM_INCLUDE=/home/user \
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

ENV LD_LIBRARY_PATH="${LIBDIR}:${LD_LIBRARY_PATH}"

RUN mkdir bin
RUN cd FISOC && make && make install

COPY fool-roms/FISOC_config.rc /home/user/FISOC_config.rc
COPY fool-roms/ocean_isomip_plus_sm.in /home/user/ocean_isomip_plus_sm.in
COPY fool-roms/isomip_grd.v6.2km.nc /home/user/isomip_grd.v6.2km.nc
COPY fool-roms/ocean3.grd.v02.nc /home/user/ocean3.grd.v02.nc
