#!/bin/env sh

##
# Install the GDAL dependencies
#
# This is based on instructions at
# <https://github.com/OSGeo/gdal/blob/trunk/.travis.yml>.
#

die() {
    exit 1
}


# Change to the source directory.
cd /tmp/gdal || die

#mv /etc/apt/sources.list.d/pgdg-source.list* /tmp
add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable || die
add-apt-repository -y ppa:marlam/gta || die
apt-get update -y || die
apt-get install -y python-numpy libpq-dev libpng12-dev libjpeg-dev libgif-dev liblzma-dev libgeos-dev libcurl4-gnutls-dev libproj-dev libxml2-dev libexpat-dev libxerces-c-dev libnetcdf-dev netcdf-bin libpoppler-dev libspatialite-dev gpsbabel swig libhdf4-alt-dev libhdf5-serial-dev libpodofo-dev poppler-utils libfreexl-dev unixodbc-dev libwebp-dev openjdk-7-jdk libepsilon-dev libgta-dev liblcms2-2 libpcre3-dev mercurial cmake || die
apt-get install -y python-lxml || die
apt-get install -y python-pip || die
pip install pyflakes || die
pyflakes autotest
pyflakes gdal/swig/python/scripts
pyflakes gdal/swig/python/samples
wget --no-verbose http://s3.amazonaws.com/etc-data.koordinates.com/gdal-travisci/FileGDB_API_1_2-64.tar.gz || die
wget --no-verbose http://s3.amazonaws.com/etc-data.koordinates.com/gdal-travisci/MrSID_DSDK-8.5.0.3422-linux.x86-64.gcc44.tar.gz || die
wget --no-verbose http://s3.amazonaws.com/etc-data.koordinates.com/gdal-travisci/install-libecwj2-ubuntu12.04-64bit.tar.gz || die
wget --no-verbose http://s3.amazonaws.com/etc-data.koordinates.com/gdal-travisci/install-libkml-r864-64bit.tar.gz || die
wget --no-verbose http://s3.amazonaws.com/etc-data.koordinates.com/gdal-travisci/install-openjpeg-2.0.0-ubuntu12.04-64bit.tar.gz || die
tar xzf MrSID_DSDK-8.5.0.3422-linux.x86-64.gcc44.tar.gz || die
cp -r MrSID_DSDK-8.5.0.3422-linux.x86-64.gcc44/Raster_DSDK/include/* /usr/local/include || die
cp -r MrSID_DSDK-8.5.0.3422-linux.x86-64.gcc44/Raster_DSDK/lib/* /usr/local/lib || die
cp -r MrSID_DSDK-8.5.0.3422-linux.x86-64.gcc44/Lidar_DSDK/include/* /usr/local/include || die
cp -r MrSID_DSDK-8.5.0.3422-linux.x86-64.gcc44/Lidar_DSDK/lib/* /usr/local/lib || die
tar xzf FileGDB_API_1_2-64.tar.gz || die
cp -r FileGDB_API/include/* /usr/local/include || die
cp -r FileGDB_API/lib/* /usr/local/lib || die
tar xzf install-libecwj2-ubuntu12.04-64bit.tar.gz || die
cp -r install-libecwj2/include/* /usr/local/include || die
cp -r install-libecwj2/lib/* /usr/local/lib || die
tar xzf install-libkml-r864-64bit.tar.gz || die
cp -r install-libkml/include/* /usr/local/include || die
cp -r install-libkml/lib/* /usr/local/lib || die
tar xzf install-openjpeg-2.0.0-ubuntu12.04-64bit.tar.gz || die
cp -r install-openjpeg/include/* /usr/local/include || die
cp -r install-openjpeg/lib/* /usr/local/lib || die
wget --no-verbose https://bitbucket.org/chchrsc/kealib/get/c6d36f3db5e4.zip || die
unzip c6d36f3db5e4.zip || die
cd chchrsc-kealib-c6d36f3db5e4/trunk || die
cmake . -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DHDF5_INCLUDE_DIR=/usr/include -DHDF5_LIB_PATH=/usr/lib -DLIBKEA_WITH_GDAL=OFF || die
make -j4 || die
make install || die
cd ../.. || die
ldconfig || die

# Remove packaged GDAL.  This is an older version which can cause conflicts with
# the newer install.
apt-get remove -y libgdal-dev libgdal1h
