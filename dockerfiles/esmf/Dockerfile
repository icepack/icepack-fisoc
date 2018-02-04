FROM buildpack-deps:stretch

ENV ESMF_DIR /esmf

RUN apt-get update && apt-get -yq install \
    gfortran \
    libopenmpi2 \
    libopenmpi-dev

RUN curl -O http://www.earthsystemmodeling.org/esmf_releases/non_public/ESMF_7_0_2/esmf_7_0_2_src.tar.gz && \
    tar xvf esmf_7_0_2_src.tar.gz && \
    cd esmf && make

