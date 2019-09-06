#!/bin/bash

vivado -notrace -mode batch -source scripts/example_cmac.tcl

cd src/cmac_sync

#Copy xilinx files
cp /tmp/cmac_usplus_0_ex/imports/cmac_usplus_0_lbus_pkt_mon.v tx_sync.v
cp /tmp/cmac_usplus_0_ex/imports/cmac_usplus_0_lbus_pkt_mon.v rx_sync.v
cp /tmp/cmac_usplus_0_ex/imports/cmac_usplus_0_axi4_lite_user_if.v cmac_0_axi4_lite_user_if.v

#patch files
patch tx_sync.v tx_sync.patch
patch rx_sync.v rx_sync.patch
patch cmac_0_axi4_lite_user_if.v cmac_axi4_lite.patch
