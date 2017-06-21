#!/bin/bash

PROJECTS=${HOME}/projects

sudo apt-get install -y \
    libglew-dev \
    libtiff5-dev \
    zlib1g-dev \
    libjpeg-dev \
    libpng12-dev \
    libjasper-dev \
    libavcodec-dev \
    libavformat-dev \
    libavutil-dev \
    libpostproc-dev \
    libswscale-dev \
    libeigen3-dev \
    libtbb-dev \
    libgtk2.0-dev \
    cmake \
    pkg-config

# Python 2.7
sudo apt-get install -y python-dev python-numpy python-py python-pytest

# Python 3.5
sudo apt-get install -y python3-numpy libpython3-dev

cd ${PROJECTS}/opencv
if [ ! -d opencv ]; then
  git clone https://github.com/opencv/opencv.git
else
  echo "opencv directory appears to exist, skipping checkout"
fi

cd opencv
git clean -dxf
git checkout -b v3.2.0 3.2.0


# This is for the test data
cd ${PROJECTS}/opencv
if [ ! -d opencv_extra ]; then
  git clone https://github.com/opencv/opencv_extra.git
else
  echo "opencv_extra directory appears to exist, skipping checkout"
fi

cd opencv_extra
git clean -dxf
git checkout -b v3.2.0 3.2.0

cd ${PROJECTS}/opencv/opencv
mkdir build
cd build
# Jetson TX2 
cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DBUILD_SHARED_LIBS=OFF \
    -DBUILD_PNG=ON \
    -DWITH_PNG=ON \
    -DBUILD_TIFF=ON \
    -DWITH_TIFF=ON \
    -DBUILD_TBB=OFF \
    -DBUILD_JPEG=ON \
    -DWITH_JPEG=ON \
    -DBUILD_JASPER=OFF \
    -DBUILD_EXAMPLES=ON \
    -DBUILD_opencv_java=ON \
    -DBUILD_opencv_python2=ON \
    -DBUILD_opencv_python3=OFF \
    -DBUILD_EXAMPLES=ON \
    -DBUILD_opencv_java=ON \
    -DBUILD_opencv_python2=ON \
    -DBUILD_opencv_python3=OFF \
    -DBUILD_opencv_apps=OFF \
    -DBUILD_opencv_cudabgsegm=OFF \
    -DBUILD_opencv_cudalegacy=OFF \
    -DBUILD_opencv_cudaoptflow=OFF \
    -DBUILD_opencv_flann=OFF \
    -DBUILD_opencv_ml=OFF \
    -DBUILD_opencv_photo=OFF \
    -DBUILD_opencv_shape=OFF \
    -DBUILD_opencv_superres=OFF \
    -DBUILD_opencv_videostab=OFF \
    -DBUILD_SHARE_LIBS=ON \
    -DENABLE_PRECOMPILED_HEADERS=OFF \
    -DWITH_OPENCL=OFF \
    -DWITH_OPENMP=OFF \
    -DWITH_FFMPEG=ON \
    -DWITH_GSTREAMER=OFF \
    -DWITH_GSTREAMER_0_10=OFF \
    -DWITH_CUDA=ON \
    -DWITH_GTK=ON \
    -DWITH_VTK=OFF \
    -DWITH_TBB=ON \
    -DWITH_1394=OFF \
    -DWITH_OPENEXR=OFF \
    -DWITH_IPP=OFF \
    -DWITH_V4L=OFF \
    -DWITH_WEBP=OFF \
    -DCUDA_FAST_MATH=ON \
    -DCUDA_NVCC_FLAGS="--default-stream per-thread -O3" \
    -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-8.0 \
    -DCUDA_ARCH_BIN=6.2 \
    -DCUDA_ARCH_PTX=6.2 \
    -DINSTALL_C_EXAMPLES=ON \
    -DINSTALL_TESTS=ON \
    -DOPENCV_TEST_DATA_PATH=../opencv_extra/testdata \
    ../

# Consider using all 6 cores; $ sudo nvpmodel -m 2 or $ sudo nvpmodel -m 0
make -j6
