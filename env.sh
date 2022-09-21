
# echo "sync submodule..."
# git submodule update --init --recursive

echo "install openssl..."
apt install openssl libssl-dev -y

echo "install curl library..."
apt-get install libcurl4-openssl-dev curl -y

echo "install fuse..."
apt install fuse -y

echo "install protobuf library..."
apt install libprotobuf-dev protobuf-compiler -y

echo "install pkg-config..."
apt install pkg-config -y

echo "install ninja..."
apt install ninja-build -y

echo "install other dependencies..."
apt install mesa-common-dev libglu1-mesa-dev -y

echo "trying to install grpc..."

echo "install grpc dependency"
apt install autoconf automake libtool make g++ unzip -y
apt install libflags-dev libtest-dev -y
apt install clang libc++-dev -y

echo "apt install libfcitx5-qt-dev fcitx5-frontend-qt5..."
apt install fcitx5-frontend-qt5 -y

export http_proxy=http://192.168.3.84:19999
export https_proxy=http://192.168.3.84:19999

echo "clone grpc...."
git clone https://github.com/grpc/grpc -b v1.49.x
cd grpc && git submodule update --init --recursive

# echo "build && install protobuf"
# cd third_party/protobuf 
# bash autogen.sh && ./configure --prefix=/usr/local/share/protobuf
# make && make install 
# cd ../..
echo "build && install grpc"
mkdir build 
cd build
# cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr/local/share/grpc -GNinja ..
cmake -GNinja .. && cmake --build . && cmake --install .


echo "config PKG_CONFIG_PATH for grpc/grpc++..."
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/share/grpc/lib/pkgconfig/