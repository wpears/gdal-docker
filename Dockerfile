##
# geodata/gdal
#
# This creates an Ubuntu derived base image that installs the latest GDAL
# subversion checkout compiled with a broad range of drivers.  The build
# process closely follows that defined in
# <https://github.com/OSGeo/gdal/blob/trunk/.travis.yml>
#

# Ubuntu 14.04 Trusty Tahyr
FROM ubuntu:trusty

MAINTAINER Homme Zwaagstra <hrz@geodata.soton.ac.uk>

# Ensure the package repository is up to date
RUN apt-get update -y

# Install basic dependencies
RUN apt-get install -y \
    software-properties-common \
    python-software-properties \
    build-essential \
    wget \
    subversion \
    openjdk-7-jdk \
    unzip

# Get the GDAL source
ADD ./gdal-checkout.txt /tmp/gdal-checkout.txt
ADD ./get-gdal.sh /tmp/
RUN sh /tmp/get-gdal.sh

# Install the GDAL source dependencies
ADD ./install-gdal-deps.sh /tmp/
RUN sh /tmp/install-gdal-deps.sh

# Install GDAL itself
ADD ./install-gdal.sh /tmp/
RUN sh /tmp/install-gdal.sh

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Externally accessible data is by default put in /data
WORKDIR /data
VOLUME ["/data"]

# Output version and capabilities by default.
CMD gdalinfo --version && gdalinfo --formats && ogrinfo --formats
