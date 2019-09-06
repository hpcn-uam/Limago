# Host Code

*This README explains how to download, compile and install the Xilinx PCI Express DMA driver.*

## Table of Contents
1. [How to get the source code](#source-code)
2. [Download driver](#download-and-uncompress-file)
3. [Compile Driver](#compile-driver-and-user-files)
4. [Load Driver](#load-driver)
5. [Troubleshooting](#troubleshooting)

## Source Code

The driver source code is published as an Answer Record [AR# 65444](https://www.xilinx.com/support/answers/65444.html). At the time of writing this is the [latest version](https://www.xilinx.com/Attachment/Xilinx_Answer_65444_Linux_Files_rel20180420.zip)

## Download and uncompress file

To simplify the process a script is included to download and uncompress the driver.

```
./download_driver.sh
```

This script will create the Xilinx_DMA_Driver folder, with the necessaries files on it.

## Compile Driver and User files

The process is as easy as 

```
make
```

The folder bin will be generated, this folder contains the following files
- xdma.ko (driver kernel object). Handles the low-level communication with the Xilinx PCI Express DMA.
- cmac_stats . Provides a means to communicate with the CMAC core, statistics can be read from it.
- performance_debug . Provides an interface to read the statistics of the internal probes.
- reg_rw . A generic programme to read or write to memory mapped register on the FPGA.
- dma_from_device . A generic programme to configure the card to host transfers.

## Load Driver

Bare in mind that after programming the FPGA the HOST must be reset in order to be able to access to the memory mapped registers. So, after the reboot, you can load the driver using the following script.

```
sudo ./load_driver.sh
``` 

After inserting the driver a message will indicate if the process was successful, if so the list of devices created by the drivel will be shown. After this point the user programmes can be used.

Below you can see a list of the created devices. If you want to use `reg_rw` you must target `xdma0_user`

```
xdma0_c2h_0
xdma0_control
xdma0_events_0
xdma0_events_1
xdma0_events_10
xdma0_events_11
xdma0_events_12
xdma0_events_13
xdma0_events_14
xdma0_events_15
xdma0_events_2
xdma0_events_3
xdma0_events_4
xdma0_events_5
xdma0_events_6
xdma0_events_7
xdma0_events_8
xdma0_events_9
xdma0_h2c_0
xdma0_user
xdma0_xvc
```

## Troubleshooting 

If for any reason the driver is not loaded properly, you can check if a PCIe device was enumerated by Linux using 

```
lspci | grep "Xilinx"
```
If there is no device below you can track down the problem with the following steps.

1. Was the HOST rebooted after the FPGA was programmed?
2. Is the FPGA connected to the HOST properly?
3. Does the design meet timing?
4. Try to programme the FPGA with another bitstream, preferable one already tested.