docker build --tag esmf --file esmf/Dockerfile .

if [ ! -d FISOC ]; then
    git clone https://github.com/RupertGladstone/FISOC.git
fi

docker build --tag dummy --file dummy/Dockerfile .
