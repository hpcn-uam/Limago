# Limago 100GbE Ethernet framework with TCP/IP support

## Introduction

This repository puts together all the necessary pieces to generate Limago.

*Before generating any project check each submodule's README.md to verify that everything is set properly*

## Supported Boards

So far only the VCU118 is supported. Please check [README.md](submodules/cmac/README.md) of the CMAC wrapper to verify clock frequency.

## Cloning the repository

In order to clone this repository you need `git lfs` installed. 

This repository uses submodules and `git lfs`, check [Installing Git Large File Storage](https://help.github.com/en/articles/installing-git-large-file-storage) to install it.

```
git clone git@github.com:hpcn-uam/Limago.git --recursive
```

## How to build the projects

The process is fully automated.

1.The first part consist on generating the necessary IP-Cores
```
make ips
```

2. Generate Vivado Project.

a. Check available projects
```
make help
```

b. Create Project
```
make create_prj_vcu118-fns-single-toe-iperf
```

Once the project is create you can open it. The project are create under the folder `project/<project_name>`

For instance you can open the project with Vivado:

```
vivado project/vcu118-fns-single-toe-iperf/vcu118-fns-single-toe-iperf.xpr
```

3. Implement project 

You can either launch it manually from the GUI or using the following command:

```
make implement_prj_vcu118-fns-single-toe-iperf
```

*It is recommended to close the GUI when launching this command.*


## Citation
If you use Limago, the [TCP/IP stack](https://github.com/hpcn-uam/100G-fpga-network-stack-core) or the [checksum computation](https://github.com/hpcn-uam/efficient_checksum-offload-engine) in your project please cite one of the following papers and/or link to the github project:

```
@inproceedings{sutter2018fpga,
    title={{FPGA-based TCP/IP Checksum Offloading Engine for 100 Gbps Networks}},
    author={Sutter, Gustavo and Ruiz, Mario and L{\'o}pez-Buedo, Sergio and Alonso, Gustavo},
    booktitle={2018 International Conference on ReConFigurable Computing and FPGAs (ReConFig)},
    year={2018},
    organization={IEEE},
    doi={10.1109/RECONFIG.2018.8641729},
    ISSN={2640-0472},
    month={Dec},
}
@INPROCEEDINGS{ruiz2019tcp, 
    title={{Limago: an FPGA-based Open-source 100~GbE TCP/IP Stack}}, 
    author={Ruiz, Mario and Sidler, David and Sutter, Gustavo and Alonso, Gustavo and L{\'o}pez-Buedo, Sergio},
    booktitle={Field Programmable Logic and Applications (FPL), 2019 29th International Conference on},
    year={2019},
    month={Sep},
    organization={IEEE},
    doi={},
}
```

# Acknowledgments

This is a collaborative project between: 
- HPCN group of the  Universidad Autónoma de Madrid. [web](http://www.hpcn-uam.es/)
- The spin-off Naudit HPCN. [web](http://www.naudit.es/en/)
- Systems Group of  ETH Zürich University. [web](https://www.systems.ethz.ch/)

So far these people have contributed to Limago
- José Fernando Zazo josefernando.zazo@naudit.es
- Mario Ruiz mario.ruiz@uam.es
- David Sidler david.sidler@inf.ethz.ch
- Gustavo Sutter gustavo.sutter@uam.es
- Gustavo Alonso alonso@inf.ethz.ch
- Sergio López-Buedo sergio.lopez-buedo@uam.es

## License

This project is a collaboration between the Systems Group of ETH Zürich, Switzerland and HPCN Group of UAM, Spain. Furthermore, the starting point of this implementation is the [Scalable 10Gbps TCP/IP Stack Architecture for Reconfigurable Hardware](https://ieeexplore.ieee.org/abstract/document/7160037) by Sidler, D et al. The original implementation can be found in their [github](https://github.com/fpgasystems/fpga-network-stack).

For this project we keep the BSD 3-Clause License

```
BSD 3-Clause License

Copyright (c) 2019, 
HPCN Group, UAM Spain (hpcn-uam.es)
Systems Group, ETH Zurich (systems.ethz.ch)
All rights reserved.


Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

* Neither the name of the copyright holder nor the names of its
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```