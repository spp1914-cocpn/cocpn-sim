#!/bin/bash

docker run --rm  -it \
	-v "$(pwd):/root/models" \
	-v /usr/local/MATLAB/R2021b/:/opt/matlab \
	-w /root/cocpn-sim \
        -e MATLAB_PREFDIR=/tmp/.matlab/ \
	-e MCR_CACHE_ROOT=/tmp/.mcr \
	--mac-address="your MAC address" \
	cocpn-sim:latest 



# replace /usr/local/MATLAB/R2021b/ in the above command with the location of your Matlab installation
# replace "your MAC address" with your MAC address (required for MATLAB license)
# the last align assumes that you created an image with name cocpn-sim via the -t option  
# docker build -t cocpn-sim .
