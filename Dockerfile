FROM omnetpp/omnetpp-base:u18.04 as base 
MAINTAINER Rudolf Hornig <rudi@omnetpp.org>

RUN apt-get update

# General dependencies, according to Ryan Kurte
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y libwebkitgtk-1.0-0 tcl-dev tk-dev perl xvfb build-essential
#  git \
#  wget \
#  vim \
#  build-essential \
#  clang \
#  bison \
#  flex \
#  perl \
#  tcl-dev 
#  tk-dev \
#  libxml2-dev \
#  zlib1g-dev \
#  default-jre \
#  graphviz \
#  libwebkitgtk-1.0-0 \
#  xvfb

RUN apt-get remove -y clang clang-6.0

#
# first stage - download and build omnet (customized version from github)
FROM base as builder
WORKDIR /root
RUN wget -O omnet-master.tar.gz https://github.com/spp1914-cocpn/omnetpp/archive/master.tar.gz && \
        tar xf omnet-master.tar.gz
RUN mv omnetpp-master omnetpp
WORKDIR /root/omnetpp
RUN echo "WITH_QTENV=no" >> configure.user
RUN echo "WITH_TKENV=no" >> configure.user
RUN echo "WITH_OSG=no" >> configure.user
RUN echo "WITH_OSGEARTH=no" >> configure.user
ENV PATH /root/omnetpp/bin:$PATH
# remove unused files and build xvfb-run
RUN xvfb-run ./configure && \
    make -j $(nproc)  && \
    rm -r doc out test misc config.status
WORKDIR /root
RUN rm omnet-master.tar.gz

#
# second stage - copy only the final binaries (to get rid of the 'out' folder and reduce the image size)
FROM base
ARG VERSION=5.6.2
ENV OPP_VER=$VERSION
RUN mkdir -p /root/omnetpp
WORKDIR /root/omnetpp
COPY --from=builder /root/omnetpp/ .
ENV PATH /root/omnetpp/bin:$PATH
RUN chmod 775 /root/ && \
    mkdir -p /root/models && \
    chmod 775 /root/models && \
    chmod 775 /root/omnetpp
WORKDIR /root/models
RUN echo 'PS1="omnetpp-$OPP_VER:\w\$ "' >> /root/.bashrc && chmod +x /root/.bashrc && \
    touch /root/.hushlogin
ENV HOME=/root/
CMD /bin/bash --init-file /root/.bashrc

# install some additional stuff
# full boost library for simplicity
RUN apt update
RUN apt-get install -y libx11-6 && apt-get install -y libxext-dev
RUN apt-get install -y libxt-dev vim
RUN apt-get install -y net-tools
RUN apt-get install -y libboost-all-dev 


# clone cocpn-sim from repo (incl. submodules)
WORKDIR /root
RUN git clone --recurse-submodules https://github.com/spp1914-cocpn/cocpn-sim.git



