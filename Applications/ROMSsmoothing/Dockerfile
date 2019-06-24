FROM esmf

# Copy FISOC into the container image
COPY FISOC /home/user/FISOC
RUN sudo chown -R user:user FISOC .[^.]*

# Copy ROMS into the container image
COPY ROMSIceShelf /home/user/ROMSIceShelf
RUN sudo chown -R user:user ROMSIceShelf .[^.]*

# Copy application specific files into container image
COPY Applications/ROMSsmoothing /home/user/Applications
RUN sudo chown -R user:user Applications .[^.]*

# Within container, overwrite standard files with specific application files
RUN cp Applications/makefile ROMSIceShelf/ && \
    cp Applications/FISOC_config.rc FISOC/ && \
    cp Applications/FOOL_config.rc FISOC/

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
    MY_HEADER_DIR=/home/user/Applications \
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
    FISOC_ISM="FOOL" \
    FISOC_ISM_LIBS="-lnetcdff" \
    FISOC_ISM_LIBPATH=/home/user \
    FISOC_ISM_INCLUDE=/home/user \
    FISOC_ISM_GEOM="FISOC_ISM_GRID" \
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
RUN mkdir Output
RUN cd FISOC && make clean && make install

## Application is now ready to run ##
## To run interactively, comment out the rest of this file and ##
## use docker run command as described in icepack-fisoc README ##

## Docker run command: ##
##docker run --interactive --tty --volume /media/mnemoniko/Oolong/Output/test:/home/user/Output fool-roms-smooth bash ##

## NOTE - THIS IS NOT CURRENTLY WORKING, ROMS cannot create a history file when the volume is included in the docker run command ##

#CMD cd FISOC && mpirun -np 4 FISOC_caller > tooMuchOutput.out


