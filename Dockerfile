#
# Ubuntu Dockerfile
#
# https://github.com/dockerfile/ubuntu
#

# Pull base image.
FROM ubuntu:12.04

# Install.
RUN \
 sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
 apt-get update && \
 apt-get -y upgrade && \
 apt-get install -y aptitude && \
 aptitude install -y build-essential && \
 aptitude install -y software-properties-common && \
 aptitude install -y byobu curl git htop man unzip vim wget && \
 rm -rf /var/lib/apt/lists/* && \
 wget http://packages.kitware.com/download/item/6175/qt-everywhere-opensource-src-4.8.6.tar.gz && \
 md5=$(md5sum ./qt-everywhere-opensource-src-4.8.6.tar.gz | awk '{ print $1 }') && \
 [ $md5 == "2edbe4d6c2eff33ef91732602f3518eb" ] && \
 rm qt-everywhere-opensource-src-4.8.6.tar.gz && \
 mv qt-everywhere-opensource-src-4.8.6 qt-everywhere-opensource-release-src-4.8.6 && \
 mkdir qt-everywhere-opensource-release-build-4.8.6 && \
 cd qt-everywhere-opensource-release-src-4.8.6 && \
 LD=${CXX} ./configure -prefix /usr/src/qt-everywhere-opensource-release-build-4.8.6 \
   -confirm-license -opensource \
   -static \
   -release \
   -no-largefile \
   -no-exceptions \
   -no-accessibility \
   -no-sql-db2 \
   -no-sql-ibase \
   -no-sql-mysql \
   -no-sql-oci \
   -no-sql-odbc \
   -no-sql-psql \
   -no-sql-sqlite \
   -no-sql-sqlite2 \
   -no-sql-sqlite_symbian \
   -no-sql-tds \
   -no-qt3support \
   -no-xmlpatterns \
   -no-multimedia \
   -no-audio-backend \
   -no-phonon \
   -no-phonon-backend \
   -no-svg \
   -no-webkit \
   -no-javascript-jit \
   -no-script \
   -no-scripttools \
   -no-declarative \
   -no-gif \
   -no-libtiff \
   -no-libmng \
   -no-openssl \
   -no-nis \
   -no-cups \
   -no-dbus \
   -no-opengl \
   -no-openvg \
   -nomake demos \
   -nomake examples \
   -no-gtkstyle && \
  make -j$(grep -c processor /proc/cpuinfo) && \
  make install && \
  find . -name '*.o' -delete


# Add files.
ADD root/.bashrc /root/.bashrc
ADD root/.gitconfig /root/.gitconfig
ADD root/.scripts /root/.scripts

# Set environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /root

# Define default command.
CMD ["bash"]
