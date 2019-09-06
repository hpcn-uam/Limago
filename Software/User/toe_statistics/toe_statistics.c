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

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <unistd.h>
#include <string.h>
#include <ctype.h>
#include <getopt.h>
#include <stdint.h>
#include <locale.h>

#include "toe_statistics.h"
#include "../common/common_functions.h"

//#define DEBUG


void usage(void) {
    printf("You can use the following arguments:\n");
    printf("     -h       : It shows help\n");
    printf("     -i <0,1> : Selects interface_offset, by default is interface_offset 0\n");
    printf("     -c <val> : Select the ID of which connection the statistics have to be read. Default 0\n");
    printf("     -r       : Read old values, does not update counters\n");
    printf("\n");
}

/**
* @brief Entry point of the program.
*
* @param argc Number of arguments
* @param argv String associated with the arguments.
*
* @return A negative value indicates en error.
*/
int main(int argc, char **argv) {

  uint32_t toe_stats_base_address;
  int      opt;
  uint32_t interface_offset = 0x0;
  uint32_t interface_num = 0;

  uint32_t update_counters=1;
  uint32_t conn_id=0;

  uint64_t tx_packets;
  uint64_t tx_bytes;
  uint64_t rx_packets;
  uint64_t rx_bytes;
  uint64_t tx_rxTx;
  uint32_t rtt;
  uint32_t conn_id_r=0xFFFF;

  if (argc > 1 ) {
    /* Parse command line arguements */
    while((opt = getopt(argc, argv, "hi:c:r")) != EOF) {
      switch(opt) {
        case 'h':
          usage();
          return 0;
        case 'c':
          conn_id = (uint32_t) atoi(optarg);
          break;  
        case 'i':
          interface_num = (uint32_t) atoi(optarg);
          if (interface_num == 0) {
            interface_offset = 0x0;
          }
          else if (interface_num == 1) {
            interface_offset = 0x10000;
          }
          else {
            printf("Error wrong interface_offset number, valid values are 0 or 1\n");
            return -1;
          }
          break;
        case 'p':
          update_counters = 0;
          break;    
        default:
          printf("invalid option: %c\n", (char)opt);
          usage();
          return -1;
      }
    }
  }

  // Map the device 
  if (map_fpga_axi4lite_device() != 0){
    printf("Error mapping device\n");
    return -1;
  }

  /* Take into account if the interface_offset number */
  toe_stats_base_address      = TOE_STATISTICS_IF0_ADDRESS + interface_offset;

  /* Write the ID of the connection to read */
  writeWord(toe_stats_base_address , XTOE_TOE_STATS_ADDR_USERID_V_DATA , conn_id);
  /* Activate read signal */ 
  if (update_counters == 1){
    writeWord(toe_stats_base_address , XTOE_TOE_STATS_ADDR_READENABLE_DATA , 0x1);
  }

  /* Read Statistics */

  tx_packets = read_two_words( toe_stats_base_address, XTOE_TOE_STATS_ADDR_TXPACKETS_V_DATA);
  tx_bytes   = read_two_words( toe_stats_base_address, XTOE_TOE_STATS_ADDR_TXBYTES_V_DATA);
  rx_packets = read_two_words( toe_stats_base_address, XTOE_TOE_STATS_ADDR_RXPACKETS_V_DATA);
  rx_bytes   = read_two_words( toe_stats_base_address, XTOE_TOE_STATS_ADDR_RXBYTES_V_DATA);
  tx_rxTx    = read_two_words( toe_stats_base_address, XTOE_TOE_STATS_ADDR_TXRETRANSMISSIONS_V_DATA);
  rtt        = readWord( toe_stats_base_address, XTOE_TOE_STATS_ADDR_CONNECTIONRTT_V_DATA);
  conn_id_r  = readWord( toe_stats_base_address, XTOE_TOE_STATS_ADDR_CONNECTIONRTT_V_DATA);
  
  /* Disable update counters */
  writeWord(toe_stats_base_address , XTOE_TOE_STATS_BITS_READENABLE_DATA , 0x0);

  setlocale(LC_NUMERIC, "");
  printf(" -----------------------------------------------------------------\n");
  printf(" |                100G TOE Statistics  Interface %1d               |\n", interface_num);
  printf(" |                      Connection ID %'4u                       |\n",(unsigned) conn_id_r);
  printf(" -----------------------------------------------------------------\n");
  printf(" |     Total       |          TX          |          RX          |\n");
  printf(" -----------------------------------------------------------------\n");
  printf(" | packets         | %'20llu | %'20llu | \n",(long long unsigned) tx_packets, (long long unsigned)rx_packets);
  printf(" | bytes           | %'20llu | %'20llu | \n",(long long unsigned) tx_bytes, (long long unsigned)rx_bytes);
  printf(" | reTx            | %'20llu |||||||||||||||||||||||| \n",(long long unsigned) tx_rxTx);
  printf(" -----------------------------------------------------------------\n");
  printf(" -----------------------------------------------------------------\n");
  printf(" | rtt             | %'20llu |                      | \n",(long long unsigned) rtt);
  printf(" -----------------------------------------------------------------\n");


  // Unmap device
  if (unmap_fpga_axi4lite_device() != 0){
    printf("Error unmapping device\n");
    return -1;
  }
  return 0;

}
