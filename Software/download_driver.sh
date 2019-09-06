#!/bin/bash 

# Get Source Code, the URL can change at any point of the time
wget https://www.xilinx.com/Attachment/Xilinx_Answer_65444_Linux_Files_rel20180420.zip -O XilinxDMADriver.zip
# Un zip the file
unzip XilinxDMADriver.zip
# Rename Folder accordingly
mv Xilinx_Answer_* Xilinx_DMA_Driver/
#Delete .zip file
rm -rf XilinxDMADriver.zip