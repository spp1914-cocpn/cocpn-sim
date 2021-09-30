#!/bin/bash

inPar=true

while getopts pnh name
do
    case $name in
    p)   inPar=true;;
    n)   inPar=false;;    
    h)	 echo "Script to run all the Matlab test cases.";
 	 echo "Available options:"
	 echo "p:      Runs the test cases in parallel, with the number of jobs dependent on the Matlab installation and the number of physical cores. This is the default option and used if called without argument";
	 echo "n:      Runs the test cases sequentially, one after the other.";	
	 echo "h:      Print this help.";
	exit 0;;
    ?)   echo "Usage: runtests [-p] [-n] [-h]";
        exit 2;;
    esac
done

cd libncs_matlab
make cleanmex
make mex -j 4
cd ..
matlab -nodisplay -r "addpath(genpath('libncs_matlab/tests'));addpath(genpath('matlab/Tests')); addpath(genpath('matlab/Classes'));addpath(genpath('matlab/external'));addpath(genpath('matlab/functions')); addpath(genpath('matlab/out')); results=[executeTestsMatlab($inPar) executeTestsLibNcsMatlab($inPar)];exit(any([results.Failed]));"

