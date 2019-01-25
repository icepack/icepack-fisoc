docker build --tag esmf --file esmf/Dockerfile .

if [ ! -d FISOC ]; then
    git clone https://github.com/RupertGladstone/FISOC.git
fi

if [ ! -d ROMSIceShelf ]; then
    git clone https://github.com/bkgf/ROMSIceShelf_devel.git ROMSIceShelf
fi

docker build --tag dummy --file dummy/Dockerfile .
docker build --tag dummy-roms --file dummy-roms/Dockerfile .
