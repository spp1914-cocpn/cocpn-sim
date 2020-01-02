# CoCPN-Sim
This is the CoCPN-Sim simulation framework. It enables joint simulations of control systems and the networks they rely on.
The different components are located in git submodules.
Please consult the documentation on ``git-submodule`` in order to learn how to use them.

CoCPN-Sim is developed by the members of the project ``CoCPN: Cooperative Cyber Physical Networking`` from the [Institute of Telematics (TM)](http://telematics.tm.kit.edu/english/index.php) and the [Intelligent Sensor-Actuator-Systems Laboratory (ISAS)](https://isas.iar.kit.edu/) of the [Karlsruhe Institute of Technology (KIT)](https://www.kit.edu/english/index.php), Germany, within the [DFG Priority Programme ``Cyber-Physical Networking (SPP 1914)``](http://spp1914.de/home/).

## In a nutshell
CoCPN-Sim provides a way to integrate components of a networked control system (NCS), modeled and simulated in MATLAB, into networks modeled with INET.
The whole simulator is based on the OMNeT++ simulation framework and has been tested with OMNeT++ 5.0 and MATLAB 2016 on Ubuntu 16.04.
It relies on the MATLAB Compiler SDK to create a shared library with ``mcc``, which is then linked into the simulation binary.
The examples in ``ncs-testbench`` show how to setup and run a simulation with CoCPN-Sim.

## Quickstart
A working installation of OMNeT++ 5.0 and MATLAB 2016b is required, in conjunction with the following MATLAB toolboxes:

* Control System Toolbox
* MATLAB Compiler
* MATLAB Compiler SDK
* Optimization Toolbox
* Signal Processing Toolbox
* Statistics and Machine Learning Toolbox

Since MATLAB provides its own set of libraries, which may conflict with system libraries (especially with glibc/libstdc++), it may be neccessary to find a MATLAB release which is suitable for your distribution, or to use a [hackaround](https://wiki.archlinux.org/index.php/matlab#MATLAB_crashes_when_displaying_graphics).
MATLAB 2016b is known to work with Ubuntu 16.04 and OMNeT++ 5.0, but OMNeT++ must be compiled without QtEnv and OpenSceneGraph-Support.

The script ``setenv.sh`` is provided in order to set up the necessary environment variables before launching the OMNeT++ IDE.
It requires you to export the variables ``OPP_ROOT`` and ``MCR_ROOT``, pointing to the root directory of OMNeT++ and MATLAB.
Then, you can source the script and launch the OMNeT++ IDE:  
``. setenv.sh``  
``omnetpp``

The OMNeT++ IDE will ask you to set up a new working space.
Proceed and import all subfolders mentioned below, except the folder ``matlab``.
Build the whole workspace.
You will then find a working example of a NCS simulation in ``ncs-testbench``.

## Architecture
The key component of CoCPN-Sim is the OMNeT++ module ``NcsContext``.
It represents a sensor, a controller and an actuator of an NCS modeled in MATLAB.
The interaction with components modeled in MATLAB is driven by a set of API functions which are called from the OMNeT++ simulation context, most of them are event-driven (like the delivery of new messages), others will be called during initialization or as periodic event to drive control computations.
Communication between the CPS components in MATLAB is modeled in messages which are fed to the OMNeT++ part of the simulation and thus subject to the network model.
Messages which are received from the network are immediately fed back to the MATLAB domain.

Descriptions of the CoCPN-Sim data flow can also be found in 
* M. Jung, F. Rosenthal, and M. Zitterbart, [*Poster Abstract: CoCPN-Sim: An Integrated Simulation Environment for Cyber-Physical Systems,*](https://doi.org/10.1109/IoTDI.2018.00040) Proceedings of the 2018 IEEE/ACM Third International Conference on Internet-of-Things Design and Implementation (IoTDI), Orlando, FL, USA, 2018.
* F. Rosenthal, M. Jung, M. Zitterbart, and Uwe D. Hanebeck, [*CoCPN – Towards Flexible and Adaptive Cyber-Physical Systems Through Cooperation,*](https://doi.org/10.1109/CCNC.2019.8651882) Proceedings of the 2019 16th IEEE Annual Consumer Communications & Networking Conference (CCNC),  Las Vegas, NV, USA, 2019. 


## Folders
* ``inet`` contains the INET framework plus the Network Simulation Cradle (NSC). With NSC, the TCP/IP stack of the Linux kernel (well, slightly outdated) may be used within the simulation.
* ``libncs_matlab`` contains the definition of the API provided to OMNeT++ by the MATLAB part of the simulation.
* ``libncs_omnet`` contains a set of modules which either interface the MATLAB API or support modelling of CPNs.
* ``matlab`` contains all MATLAB code for the co-simulation
* ``matlab-scheduler`` is not really a special scheduler but provides hooks to initialize and deinitialize the MATLAB environment
* ``ncs-testbench`` this repository shows how to build a MATLAB-OMNeT++/INET co-simulation with the components mentioned beforehand

## Unit Tests
* ``libncs_matlab``: Unit tests for ``libncs_matlab`` reside in the ``tests`` subfolder and can be run by calling the function ``executeTestsLibNcsMatlab``.
* ``matlab``: Unit tests for ``matlab`` reside in the ``Tests`` subfolder and can be run by calling the function ``executeTestsMatlab``.

## Externals
CoCPN-Sim makes use of the following external libraries/functions which are included in matlab/external.
* [Nonlinear Estimation Toolbox (GPLv3)](https://nonlinearestimation.bitbucket.io/) by Jannik Steinbring, only the required subset is included
* [YALMIP](https://yalmip.github.io/) by Johan Löfberg
* [DiscreteSample (FreeBSD)](https://de.mathworks.com/matlabcentral/fileexchange/21912-sampling-from-a-discrete-distribution) by Dahua Lin
* [mtimesx (FreeBSD)](https://de.mathworks.com/matlabcentral/fileexchange/25977-mtimesx-fast-matrix-multiply-with-multi-dimensional-support) by James Tursa
* [Armadillo (Apache)](http://arma.sourceforge.net/) by Conrad Sanderson and Ryan Curtin

<br>
<br>

For additional information regarding YALMIP and Armadillo, refer to the corresponding papers:
* Johan Löfberg, [YALMIP: a toolbox for modeling and optimization in MATLAB](https://doi.org/10.1109/CACSD.2004.1393890), Proceedings of the 2004 IEEE International Conference on Robotics and Automation, New Orleans, LA, USA, 2004.
* Conrad Sanderson and Ryan Curtin, [Armadillo: a template-based C++ library for linear algebra](http://arma.sourceforge.net/armadillo_joss_2016.pdf), Journal of Open Source Software, Vol. 1, pp. 26, 2016.

## License
CoCPN-Sim is licensed under the GPLv3 license.

## Citation
If you use CoCPN-Sim in your research, please cite its usage as follows.
````
@misc{cocpnSim,
  Title   = {{CoCPN-Sim}},
  Author  = {Markus Jung and Florian Rosenthal},
  Year    = {2018},
  Url     = {https://github.com/spp1914-cocpn/cocpn-sim}
}
````
## Contact
 Lead authors: Markus Jung and Florian Rosenthal
 
 Email: markus.jung(at)kit.edu, florian.rosenthal(at)kit.edu
