FROM esmf

COPY FISOC /home/user/FISOC

COPY dummy-dummy/FISOC_config.rc /home/user/FISOC_config.rc

RUN sudo chown -R user:user FISOC .[^.]*

ENV ESMFMKFILE=/home/user/esmf/lib/libO/Linux.gfortran.64.openmpi.default/esmf.mk \
    FISOC_DIR=/home/user/FISOC

ENV CPPFLAGS="$CPPFLAGS -D FISOC_MPI" \
    FFLAGS="${FFLAGS} -fbacktrace -g -O0 -fbounds-check -Wall" \
    FISOC_ISM="dummy" \
    FISOC_ISM_LIBS="" \
    FISOC_ISM_LIBPATH=/home/user \
    FISOC_ISM_INCLUDE=/home/user \
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
