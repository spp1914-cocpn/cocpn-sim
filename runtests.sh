#!/bin/bash
# USAGE: do NOT execute this script, "source" it from your shell
#	. runtests.sh

cd libncs_matlab
make clean
make -j 4
cd ..
matlab -nodisplay -r "addpath(genpath('libncs_matlab/tests'));addpath(genpath('matlab/Tests')); addpath(genpath('matlab/Classes'));addpath(genpath('matlab/external'));addpath(genpath('matlab/functions')); addpath(genpath('matlab/out')); results=[executeTestsMatlab() executeTestsLibNcsMatlab()];exit(any([results.Failed]));"

