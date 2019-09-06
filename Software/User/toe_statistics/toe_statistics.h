/************************************************
BSD 3-Clause License

Copyright (c) 2019, HPCN Group, UAM Spain (hpcn-uam.es)
and Systems Group, ETH Zurich (systems.ethz.ch)
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

#define TOE_STATISTICS_IF0_ADDRESS		  		0x8000


#define XTOE_TOE_STATS_ADDR_READENABLE_DATA          0x10
#define XTOE_TOE_STATS_BITS_READENABLE_DATA          1
#define XTOE_TOE_STATS_ADDR_USERID_V_DATA            0x18
#define XTOE_TOE_STATS_BITS_USERID_V_DATA            16
#define XTOE_TOE_STATS_ADDR_TXBYTES_V_DATA           0x20
#define XTOE_TOE_STATS_BITS_TXBYTES_V_DATA           64
#define XTOE_TOE_STATS_ADDR_TXBYTES_V_CTRL           0x28
#define XTOE_TOE_STATS_ADDR_TXPACKETS_V_DATA         0x2c
#define XTOE_TOE_STATS_BITS_TXPACKETS_V_DATA         54
#define XTOE_TOE_STATS_ADDR_TXPACKETS_V_CTRL         0x34
#define XTOE_TOE_STATS_ADDR_TXRETRANSMISSIONS_V_DATA 0x38
#define XTOE_TOE_STATS_BITS_TXRETRANSMISSIONS_V_DATA 54
#define XTOE_TOE_STATS_ADDR_TXRETRANSMISSIONS_V_CTRL 0x40
#define XTOE_TOE_STATS_ADDR_RXBYTES_V_DATA           0x44
#define XTOE_TOE_STATS_BITS_RXBYTES_V_DATA           64
#define XTOE_TOE_STATS_ADDR_RXBYTES_V_CTRL           0x4c
#define XTOE_TOE_STATS_ADDR_RXPACKETS_V_DATA         0x50
#define XTOE_TOE_STATS_BITS_RXPACKETS_V_DATA         54
#define XTOE_TOE_STATS_ADDR_RXPACKETS_V_CTRL         0x58
#define XTOE_TOE_STATS_ADDR_CONNECTIONRTT_V_DATA     0x5c
#define XTOE_TOE_STATS_BITS_CONNECTIONRTT_V_DATA     32
#define XTOE_TOE_STATS_ADDR_CONNECTIONRTT_V_CTRL     0x60