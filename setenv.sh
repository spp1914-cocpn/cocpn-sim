#!/bin/bash
# sets up several variables required by OMNeT++ and Matlab Compiler SDK
# USAGE: do NOT execute this script, "source" it from your shell before 
# executing omnetpp:
#	. setenv.sh
#	omnetpp

# Configure your system to export OPP_ROOT and MCR_ROOT to point to the
# install location of OMNeT++ and Matlab if they are different than the 
# values configured below

# OMNeT++
if [ -z "$OPP_ROOT" ]; then
	export OPP_ROOT="/opt/omnetpp-5.0"
fi

export PATH="$OPP_ROOT/bin:$PATH"
export LD_LIBRARY_PATH="$OPP_ROOT/lib:$LD_LIBRARY_PATH"
export HOSTNAME
export HOST

# INET Network Simulation Cradle
export LD_LIBRARY_PATH="$PWD/inet/3rdparty/nsc-0.5.3/lib:$LD_LIBRARY_PATH"

# Matlab Compiler SDK
if [ -z "$MCR_ROOT" ]; then
	export MCR_ROOT="/opt/matlab"
fi

export PATH="$MCR_ROOT/bin:$PATH"
export XAPPLESDIR="$MCR_ROOT/X11/app-defaults"
export NON_MATLAB_LD_LIBRARY_PATH="$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH="/usr/lib/x86_64-linux-gnu:$MCR_ROOT/runtime/glnxa64:$MCR_ROOT/bin/glnxa64:$MCR_ROOT/sys/os/glnxa64:$LD_LIBRARY_PATH"

