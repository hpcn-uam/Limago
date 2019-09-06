/************************************************
BSD 3-Clause License

Copyright (c) 2019, HPCN Group, UAM Spain (hpcn-uam.es)
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

************************************************/

#define CMAC_INTERFACE0_ADDRESS			  		0x0000

#define CMAC_MODE_REG 					  		0x0008
#define CONFIGURATION_TX_REG1			  		0x000C
#define CONFIGURATION_RX_REG1			  		0x0014
#define GT_LOOPBACK_REG 				  		0x0090	 


#define CORE_VERSION_REG                  		0x0024
#define STAT_TX_TOTAL_PACKETS             		0x0500
#define STAT_TX_TOTAL_GOOD_PACKETS        		0x0508
#define STAT_TX_TOTAL_BYTES               		0x0510
#define STAT_TX_PACKET_64_BYTES           		0x0520
#define STAT_TX_PACKET_65_127_BYTES       		0x0528
#define STAT_TX_PACKET_128_255_BYTES      		0x0530
#define STAT_TX_PACKET_256_511_BYTES      		0x0538
#define STAT_TX_PACKET_512_1023_BYTES     		0x0540
#define STAT_TX_PACKET_1024_1518_BYTES    		0x0548
#define STAT_TX_PACKET_1519_1522_BYTES    		0x0550
#define STAT_TX_PACKET_1523_1548_BYTES    		0x0558
#define STAT_TX_PACKET_1549_2047_BYTES    		0x0560
#define STAT_TX_PACKET_2048_4095_BYTES    		0x0568
#define STAT_TX_PACKET_4096_8191_BYTES    		0x0570
#define STAT_TX_PACKET_8192_9215_BYTES    		0x0578
#define STAT_RX_TOTAL_PACKETS             		0x0608
#define STAT_RX_TOTAL_GOOD_PACKETS        		0x0610
#define STAT_RX_TOTAL_BYTES               		0x0618
#define STAT_RX_BAD_FCS                   		0x06c0
#define STAT_RX_PACKET_BAD_FCS            		0x06c8
#define STAT_RX_STOMPED_FCS               		0x06d0
#define STAT_RX_PACKET_64_BYTES           		0x0628
#define STAT_RX_PACKET_65_127_BYTES       		0x0630
#define STAT_RX_PACKET_128_255_BYTES      		0x0638
#define STAT_RX_PACKET_256_511_BYTES      		0x0640
#define STAT_RX_PACKET_512_1023_BYTES     		0x0648
#define STAT_RX_PACKET_1024_1518_BYTES    		0x0650
#define STAT_RX_PACKET_1519_1522_BYTES    		0x0658
#define STAT_RX_PACKET_1523_1548_BYTES    		0x0660
#define STAT_RX_PACKET_1549_2047_BYTES    		0x0668
#define STAT_RX_PACKET_2048_4095_BYTES    		0x0670
#define STAT_RX_PACKET_4096_8191_BYTES    		0x0678
#define STAT_RX_PACKET_8192_9215_BYTES    		0x0680
#define STAT_RX_TOTAL_GOOD_BYTES          		0x0620
#define STAT_TX_FRAME_ERROR               		0x0458
#define STAT_TX_BAD_FCS                   		0x05B8
#define STAT_TX_PAUSE                     		0x05F0
#define STAT_TX_USER_PAUSE                		0x05F8
#define STAT_RX_PAUSE                     		0x06F8
#define STAT_RX_USER_PAUSE                		0x0700
#define STAT_TX_TOTAL_GOOD_BYTES          		0x0518
#define STAT_TX_PACKET_LARGE              		0x0580
#define STAT_TX_PACKET_SMALL              		0x0588
#define STAT_RX_PACKET_LARGE              		0x0688
#define STAT_RX_PACKET_SMALL              		0x0690
#define STAT_RX_TRUNCATED                 		0x0710
#define STAT_RX_BAD_CODE                  		0x0418
#define STAT_RX_UNDERSIZE                 		0x0698
#define STAT_RX_FRAGMENT                  		0x06A0
#define STAT_RX_TOOLONG                   		0x06B0
#define STAT_RX_JABBER                    		0x06B8
#define STAT_CYCLE_COUNT                  		0x02B8
#define STAT_RX_STATUS_REG                		0x0204
#define STAT_RX_BLOCK_LOCK_REG            		0x0210
#define STAT_RX_LANE_SYNC_REG             		0x0210
#define STAT_RX_LANE_SYNC_ERR_REG         		0x0214
#define STAT_RX_LANE_AM_ERR_REG           		0x0218
#define STAT_RX_LANE_AM_LEN_ERR_REG       		0x021C
#define STAT_RX_LANE_AM_REPEAT_ERR_REG    		0x0220
#define STAT_RX_LANE_DEMUXED              		0x0224
#define STAT_TX_STATUS_REG                		0x0200
#define PM_TICK_REGISTER 						0x02B0

#define QSFP28_CAGE_0_CONTROL_BASE_ADDR	  		0x2000	
#define QSFP28_CAGE_CONTROL_PHY_SIGNALS_OUT   	0x0
#define QSFP28_CAGE_CONTROL_PHY_SIGNALS_IN    	0x4