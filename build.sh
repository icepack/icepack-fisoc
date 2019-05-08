docker build --tag esmf --file esmf/Dockerfile .

if [ ! -d FISOC ]; then
    git clone --branch devel https://github.com/RupertGladstone/FISOC.git
fi

if [ ! -d ROMSIceShelf ]; then
    git clone --branch mack_local https://github.com/bkgf/ROMSIceShelf_devel.git ROMSIceShelf
fi

if [ ! -d elmerfem ]; then
    git clone --branch elmerice_FISOC https://github.com/ElmerCSC/elmerfem.git elmerfem
fi

docker build --tag dummy-dummy --file dummy-dummy/Dockerfile .
docker build --tag dummy-roms --file dummy-roms/Dockerfile .
docker build --tag fool-roms --file fool-roms/Dockerfile .
docker build --tag elmer-roms --file elmer-roms/Dockerfile .
