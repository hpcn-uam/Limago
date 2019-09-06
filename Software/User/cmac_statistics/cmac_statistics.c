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

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <unistd.h>
#include <string.h>
#include <ctype.h>
#include <getopt.h>
#include <stdint.h>
#include <locale.h>

#include "cmac_statistics.h"
#include "../common/common_functions.h"

//#define DEBUG

#define BOOL_FMT(bool_expr) "%s", (bool_expr) ? "Yes" : "No "
#define CAUI_MODE(bool_expr) "%s", (bool_expr) ? "CAUI4 " : "CAUI10"

void readFromPhysicalCore( uint32_t base_addr)
{
  writeWord(base_addr , PM_TICK_REGISTER, 1);      // TICK_REG
}

void usage(void) {
    printf("You can use the following arguments:\n");
    printf("     -h : It shows help\n");
    printf("     -i <0,1> : Selects interface_offset, by default is interface_offset 0\n");
    printf("     -d : Debug Mode, it shows extra alignment register\n");
    printf("     -e : Debug Mode, it shows extra registers\n");
    printf("     -m : Module Debug, f.e. if is present or module operation fault\n");
    printf("     -l : Show if there is Link\n");
    printf("     -r : Read old register, this mode does not activate pm_tick\n");
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

  uint32_t cmac_base_addr;
  uint32_t qsfp_cage_base_addr;
  uint32_t cmac_version,cmac_mode;
  uint32_t conf_tx,conf_rx,gt_loop;

  uint64_t rx_pkt,tx_pkt;
  uint64_t rx_pkt_good,tx_pkt_good;
  uint64_t rx_bytes,tx_bytes;
  uint64_t rx_bytes_good,tx_bytes_good;
  uint64_t rx_bad_fcs,tx_bad_fcs;
  uint64_t rx_pkt_bad_fcs,rx_stomped_bad_fcs;

  uint64_t rx_0_64,tx_0_64;
  uint64_t rx_65_127,tx_65_127;
  uint64_t rx_128_255,tx_128_255;
  uint64_t rx_256_511,tx_256_511;
  uint64_t rx_512_1023,tx_512_1023;
  uint64_t rx_1024_1518,tx_1024_1518;
  uint64_t rx_1519_1522,tx_1519_1522;
  uint64_t rx_1523_1548,tx_1523_1548;
  uint64_t rx_1549_2047,tx_1549_2047;
  uint64_t rx_2048_4095,tx_2048_4095;
  uint64_t rx_4096_8191,tx_4096_8191;
  uint64_t rx_8192_9215,tx_8192_9215;
  uint64_t rx_small,tx_small;
  uint64_t rx_large,tx_large;
  uint64_t tx_frame_err;
  uint64_t rx_pause,tx_pause;
  uint64_t rx_user_pause,tx_user_pause;
  uint64_t rx_bad_code;
  uint64_t rx_under_si,rx_frag,rx_too_lo,rx_jabber;
  uint32_t rx_status_reg,rx_block_lock,rx_lane_synq;
  uint32_t rx_lane_am_err,rx_lane_am_repeat,rx_lane_demux;
  uint32_t rx_lane_synq_err,rx_lane_am_len_err;  
  uint32_t tx_status_reg;  
  uint32_t module_signals_in;  
  uint32_t module_signals_out;  

  uint64_t cycle_count;

  uint8_t  debug    =  0;
  uint8_t  pm_tick  =  1;
  uint8_t  module   =  0; 
  uint8_t  link     =  0; 
  uint8_t  extra    =  0; 
  uint8_t  link_detected = 0;
  int      opt;
  uint32_t interface_offset = 0x0;
  uint32_t interface_num = 0;

  if (argc > 1 ) {
    /* Parse command line arguements */
    while((opt = getopt(argc, argv, "hi:drmle")) != EOF) {
      switch(opt) {
        case 'h':
          usage();
          return 0;
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
        case 'd':
          pm_tick  =0;
          debug    =1;
          break;
        case 'm':
          module   =1;
          break;
        case 'r':
          pm_tick  =0;
          break;
        case 'l':
          pm_tick  =0;
          link  = 1;
          break; 
        case 'e':
          extra = 1;
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
  cmac_base_addr      = CMAC_INTERFACE0_ADDRESS + interface_offset;
  qsfp_cage_base_addr = QSFP28_CAGE_0_CONTROL_BASE_ADDR + interface_offset;

  if (pm_tick==1)  {  // Update cmac register or read the old ones
      readFromPhysicalCore(cmac_base_addr);
  }

  cmac_version  = readWord(      cmac_base_addr, CORE_VERSION_REG        );
  cmac_mode     = readWord(      cmac_base_addr, CMAC_MODE_REG           );
  conf_tx       = readWord(      cmac_base_addr, CONFIGURATION_TX_REG1   );
  conf_rx       = readWord(      cmac_base_addr, CONFIGURATION_RX_REG1   );
  gt_loop       = readWord(      cmac_base_addr, GT_LOOPBACK_REG         );


  /* tx registers */

  tx_pkt        = read_two_words( cmac_base_addr, STAT_TX_TOTAL_PACKETS           );
  tx_pkt_good   = read_two_words( cmac_base_addr, STAT_TX_TOTAL_GOOD_PACKETS      );
  tx_bytes      = read_two_words( cmac_base_addr, STAT_TX_TOTAL_BYTES             );
  tx_bytes_good = read_two_words( cmac_base_addr, STAT_TX_TOTAL_GOOD_BYTES        );
  tx_bad_fcs    = read_two_words( cmac_base_addr, STAT_TX_BAD_FCS                 );
  tx_frame_err  = read_two_words( cmac_base_addr, STAT_TX_FRAME_ERROR             );
  tx_0_64       = read_two_words( cmac_base_addr, STAT_TX_PACKET_64_BYTES         );
  tx_65_127     = read_two_words( cmac_base_addr, STAT_TX_PACKET_65_127_BYTES     );
  tx_128_255    = read_two_words( cmac_base_addr, STAT_TX_PACKET_128_255_BYTES    );
  tx_256_511    = read_two_words( cmac_base_addr, STAT_TX_PACKET_256_511_BYTES    );
  tx_512_1023   = read_two_words( cmac_base_addr, STAT_TX_PACKET_512_1023_BYTES   );
  tx_1024_1518  = read_two_words( cmac_base_addr, STAT_TX_PACKET_1024_1518_BYTES  );
  tx_1519_1522  = read_two_words( cmac_base_addr, STAT_TX_PACKET_1519_1522_BYTES  );
  tx_1523_1548  = read_two_words( cmac_base_addr, STAT_TX_PACKET_1523_1548_BYTES  );
  tx_1549_2047  = read_two_words( cmac_base_addr, STAT_TX_PACKET_1549_2047_BYTES  );
  tx_2048_4095  = read_two_words( cmac_base_addr, STAT_TX_PACKET_2048_4095_BYTES  );
  tx_4096_8191  = read_two_words( cmac_base_addr, STAT_TX_PACKET_4096_8191_BYTES  );
  tx_8192_9215  = read_two_words( cmac_base_addr, STAT_TX_PACKET_8192_9215_BYTES  );
  tx_small      = read_two_words( cmac_base_addr, STAT_TX_PACKET_SMALL            );
  tx_large      = read_two_words( cmac_base_addr, STAT_TX_PACKET_LARGE            );

  /* rx registers */

  rx_pkt              = read_two_words( cmac_base_addr, STAT_RX_TOTAL_PACKETS         );
  rx_pkt_good         = read_two_words( cmac_base_addr, STAT_RX_TOTAL_GOOD_PACKETS    );
  rx_bytes            = read_two_words( cmac_base_addr, STAT_RX_TOTAL_BYTES           );
  rx_bytes_good       = read_two_words( cmac_base_addr, STAT_RX_TOTAL_GOOD_BYTES      );
  rx_bad_fcs          = read_two_words( cmac_base_addr, STAT_RX_BAD_FCS               );
  rx_pkt_bad_fcs      = read_two_words( cmac_base_addr, STAT_RX_PACKET_BAD_FCS        );
  rx_stomped_bad_fcs  = read_two_words( cmac_base_addr, STAT_RX_STOMPED_FCS           );
  rx_0_64             = read_two_words( cmac_base_addr, STAT_RX_PACKET_64_BYTES       );
  rx_65_127           = read_two_words( cmac_base_addr, STAT_RX_PACKET_65_127_BYTES   );
  rx_128_255          = read_two_words( cmac_base_addr, STAT_RX_PACKET_128_255_BYTES  );
  rx_256_511          = read_two_words( cmac_base_addr, STAT_RX_PACKET_256_511_BYTES  );
  rx_512_1023         = read_two_words( cmac_base_addr, STAT_RX_PACKET_512_1023_BYTES );
  rx_1024_1518        = read_two_words( cmac_base_addr, STAT_RX_PACKET_1024_1518_BYTES);
  rx_1519_1522        = read_two_words( cmac_base_addr, STAT_RX_PACKET_1519_1522_BYTES);
  rx_1523_1548        = read_two_words( cmac_base_addr, STAT_RX_PACKET_1523_1548_BYTES);
  rx_1549_2047        = read_two_words( cmac_base_addr, STAT_RX_PACKET_1549_2047_BYTES);
  rx_2048_4095        = read_two_words( cmac_base_addr, STAT_RX_PACKET_2048_4095_BYTES);
  rx_4096_8191        = read_two_words( cmac_base_addr, STAT_RX_PACKET_4096_8191_BYTES);
  rx_8192_9215        = read_two_words( cmac_base_addr, STAT_RX_PACKET_8192_9215_BYTES);
  rx_small            = read_two_words( cmac_base_addr, STAT_RX_PACKET_SMALL          );
  rx_large            = read_two_words( cmac_base_addr, STAT_RX_PACKET_LARGE          );
  cycle_count         = read_two_words( cmac_base_addr, STAT_CYCLE_COUNT              );


  if(debug==1 || link == 1){ // Debug registers
    tx_pause      = read_two_words(cmac_base_addr, STAT_TX_PAUSE     );
    rx_pause      = read_two_words(cmac_base_addr, STAT_RX_PAUSE     );
    tx_user_pause = read_two_words(cmac_base_addr, STAT_TX_USER_PAUSE);
    rx_user_pause = read_two_words(cmac_base_addr, STAT_RX_USER_PAUSE);
    rx_bad_code   = read_two_words(cmac_base_addr, STAT_RX_BAD_CODE  );
    rx_under_si   = read_two_words(cmac_base_addr, STAT_RX_UNDERSIZE );
    rx_frag       = read_two_words(cmac_base_addr, STAT_RX_FRAGMENT  );
    rx_too_lo     = read_two_words(cmac_base_addr, STAT_RX_TOOLONG   );
    rx_jabber     = read_two_words(cmac_base_addr, STAT_RX_JABBER    );
    
    rx_status_reg       = readWord (cmac_base_addr, STAT_RX_STATUS_REG            );
    tx_status_reg       = readWord (cmac_base_addr, STAT_TX_STATUS_REG            );
    rx_block_lock       = readWord (cmac_base_addr, STAT_RX_BLOCK_LOCK_REG        );
    rx_lane_synq        = readWord (cmac_base_addr, STAT_RX_LANE_SYNC_REG         );
    rx_lane_synq_err    = readWord (cmac_base_addr, STAT_RX_LANE_SYNC_ERR_REG     );
    rx_lane_am_err      = readWord (cmac_base_addr, STAT_RX_LANE_AM_ERR_REG       );
    rx_lane_am_len_err  = readWord (cmac_base_addr, STAT_RX_LANE_AM_LEN_ERR_REG   );
    rx_lane_am_repeat   = readWord (cmac_base_addr, STAT_RX_LANE_AM_REPEAT_ERR_REG);
    rx_lane_demux       = readWord (cmac_base_addr, STAT_RX_LANE_DEMUXED          );
  }



  setlocale(LC_NUMERIC, "");
  /* Print Registers */
  if (debug==0 && module == 0 && link == 0) {
    printf(" -----------------------------------------------------------------\n");
    printf(" |                100G NIC Statistics  Interface %1d               |\n", interface_num);
    printf(" -----------------------------------------------------------------\n");
  }
  else{
    printf(" -----------------------------------------------------------------\n");
    printf(" |                   100G NIC Debug  Interface %1d                 |\n", interface_num);
    printf(" -----------------------------------------------------------------\n");
  }


  printf(" |        Core MAC |    version -> %2u.%2u  | ", (uint8_t) ((cmac_version >> 8)& 0xff), (uint8_t) cmac_version & 0xff);
  printf("  Mode -> " CAUI_MODE(cmac_mode & 0x1));
  printf("     |\n");
  printf(" |  Loopback: " BOOL_FMT(gt_loop & 0x1));
  printf("  |    TX Enable: " BOOL_FMT(conf_tx & 0x1));
  printf("    |   Rx Enable: " BOOL_FMT(conf_rx & 0x1));
  printf("     |\n");
  if (debug==0 && module == 0 && link == 0) {
    printf(" -----------------------------------------------------------------\n");
    printf(" |     Total       |          TX          |          RX          |\n");
    printf(" -----------------------------------------------------------------\n");
    printf(" | packets         | %'20llu | %'20llu | \n",(long long unsigned) tx_pkt, (long long unsigned)rx_pkt);
    printf(" | bytes           | %'20llu | %'20llu | \n",(long long unsigned) tx_bytes, (long long unsigned)rx_bytes);
    printf(" | packets (GOOD)  | %'20llu | %'20llu | \n",(long long unsigned) tx_pkt_good, (long long unsigned)rx_pkt_good);
    printf(" | bytes  (GOOD)   | %'20llu | %'20llu | \n",(long long unsigned) tx_bytes_good, (long long unsigned)rx_bytes_good);
    printf(" | packet bad FCS  |||||||||||||||||||||||| %'20llu | \n", (long long unsigned) rx_pkt_bad_fcs);
    printf(" | bad FCS         | %'20llu | %'20llu | \n",(long long unsigned) tx_bad_fcs, (long long unsigned)rx_bad_fcs);
    printf(" | frame error     | %'20llu |||||||||||||||||||||||| \n", (long long unsigned) tx_frame_err);
  
    if(extra==1){
      printf(" | stomped bad FCS |||||||||||||||||||||||| %'20llu | \n", (long long unsigned) rx_stomped_bad_fcs);
      printf(" | pause           | %'20llu | %'20llu | \n", (long long unsigned) tx_pause, (long long unsigned) rx_pause);
      printf(" | user pause      | %'20llu | %'20llu | \n", (long long unsigned) tx_user_pause, (long long unsigned) rx_user_pause);
      printf(" | bad code        |||||||||||||||||||||||| %'20llu | \n",(long long unsigned) rx_bad_code);
    }

    printf(" -----------------------------------------------------------------\n");
    printf(" |    Histogram    |                Accumulated                  |\n");
    printf(" -----------------------------------------------------------------\n");
    printf(" |        [0,64]   | %'20llu | %'20llu | \n", (long long unsigned) tx_0_64      , (long long unsigned) rx_0_64        );
    printf(" |      [65,127]   | %'20llu | %'20llu | \n", (long long unsigned) tx_65_127    , (long long unsigned) rx_65_127      );
    printf(" |     [128,255]   | %'20llu | %'20llu | \n", (long long unsigned) tx_128_255   , (long long unsigned) rx_128_255     );
    printf(" |     [256,511]   | %'20llu | %'20llu | \n", (long long unsigned) tx_256_511   , (long long unsigned) rx_256_511     );
    printf(" |    [512,1023]   | %'20llu | %'20llu | \n", (long long unsigned) tx_512_1023  , (long long unsigned) rx_512_1023    );
    printf(" |   [1024,1518]   | %'20llu | %'20llu | \n", (long long unsigned) tx_1024_1518 , (long long unsigned) rx_1024_1518   );
    printf(" |   [1519,1522]   | %'20llu | %'20llu | \n", (long long unsigned) tx_1519_1522 , (long long unsigned) rx_1519_1522   );
    printf(" |   [1523,1548]   | %'20llu | %'20llu | \n", (long long unsigned) tx_1523_1548 , (long long unsigned) rx_1523_1548   );
    printf(" |   [1549,2047]   | %'20llu | %'20llu | \n", (long long unsigned) tx_1549_2047 , (long long unsigned) rx_1549_2047   );
    printf(" |   [2048,4095]   | %'20llu | %'20llu | \n", (long long unsigned) tx_2048_4095 , (long long unsigned) rx_2048_4095   );
    printf(" |   [4096,8191]   | %'20llu | %'20llu | \n", (long long unsigned) tx_4096_8191 , (long long unsigned) rx_4096_8191   );
    printf(" |   [8192,9215]   | %'20llu | %'20llu | \n", (long long unsigned) tx_8192_9215 , (long long unsigned) rx_8192_9215   );
    printf(" |         small   | %'20llu | %'20llu | \n", (long long unsigned) tx_small , (long long unsigned) rx_small );
    printf(" |         large   | %'20llu | %'20llu | \n", (long long unsigned) tx_large , (long long unsigned) rx_large );
    if(extra==1){ 
      printf(" |   under size    |||||||||||||||||||||||| %'20llu | \n", (long long unsigned) rx_under_si );
      printf(" |   fragment      |||||||||||||||||||||||| %'20llu | \n",(long long unsigned) rx_frag);
      printf(" |   too long      |||||||||||||||||||||||| %'20llu | \n",(long long unsigned) rx_too_lo);
      printf(" |   jabber        |||||||||||||||||||||||| %'20llu | \n",(long long unsigned) rx_jabber);
    }
    printf(" -----------------------------------------------------------------\n");
    printf(" |   cycle count   |     %'20llu                    |\n", (long long unsigned)  cycle_count);
  }
  printf(" -----------------------------------------------------------------\n");
  if(debug==1){
    printf("\n");
    printf("RX STATUS:");
    printf("\n     rx status                  : " BOOL_FMT(rx_status_reg & 0x1));
    printf("\n     rx aligned                 : " BOOL_FMT((rx_status_reg >> 1) & 0x1)) ;
    printf("\n     rx misaligned              : " BOOL_FMT((rx_status_reg >> 2) & 0x1)) ;
    printf("\n     rx aligned err             : " BOOL_FMT((rx_status_reg >> 3) & 0x1)) ;
    printf("\n     rx hi ber                  : " BOOL_FMT((rx_status_reg >> 4) & 0x1)) ;
    printf("\n     rx remote fault            : " BOOL_FMT((rx_status_reg >> 5) & 0x1)) ;
    printf("\n     rx local fault             : " BOOL_FMT((rx_status_reg >> 6) & 0x1)) ;
    printf("\n     internal local fault       : " BOOL_FMT((rx_status_reg >> 7) & 0x1)) ;
    printf("\n     received local fault       : " BOOL_FMT((rx_status_reg >> 8) & 0x1)) ;
    printf("\n     test pattern mismatch      : %d", ((rx_status_reg >> 9) & 0x3)) ;
    printf("\n     bad preamble               : " BOOL_FMT((rx_status_reg >> 12) & 0x1));
    printf("\n     bad sfd                    : " BOOL_FMT((rx_status_reg >> 13) & 0x1));
    printf("\n     got signal os              : " BOOL_FMT((rx_status_reg >> 14) & 0x1));

    printf("\n     RX BLOCK LOCK REG          : %X\n",  rx_block_lock& 0xFFFFF);
    printf("     RX LANE SYNC REG           : %X\n",  rx_lane_synq& 0xFFFFF);
    printf("     RX LANE SYNC ERR REG       : %X\n",  rx_lane_synq_err& 0xFFFFF);
    printf("     RX LANE AM ERR REG         : %X\n",  rx_lane_am_err& 0xFFFFF);
    printf("     RX LANE AM LEN ERR REG     : %X\n",  rx_lane_am_len_err& 0xFFFFF);
    printf("     RX LANE AM REPEAT ERR REG  : %X\n",  rx_lane_am_repeat& 0xFFFFF);
    printf("     RX LANE DEMUXED            : %X\n",  rx_lane_demux& 0xFFFFF);

    printf("TX STATUS:");
    printf("\n     tx local fault             : " BOOL_FMT(tx_status_reg & 0x1));
    printf("\n");
  }  

  if(module == 1) {
    printf("\n");
    module_signals_in   = readWord( qsfp_cage_base_addr, QSFP28_CAGE_CONTROL_PHY_SIGNALS_IN  );
    module_signals_out  = readWord( qsfp_cage_base_addr, QSFP28_CAGE_CONTROL_PHY_SIGNALS_OUT );
    printf("QSFP28+ MODULE STATUS:");
    printf("\n [ In]  Physically Present                       : " BOOL_FMT(module_signals_in & 0x1));
    printf("\n [ In]  Operational Fault or a Status critical   : " BOOL_FMT((module_signals_in >> 1) & 0x1)) ;
    printf("\n [Out]  Enable iic low polarity                  : " BOOL_FMT(module_signals_out & 0x1)) ;
    printf("\n [Out]  Reset low polarity                       : " BOOL_FMT((module_signals_out >> 1) & 0x1)) ;
    printf("\n [Out]  Low power                                : " BOOL_FMT((module_signals_out >> 2) & 0x1)) ;
    printf("\n");
  }

  if (link == 1) {
    // Make operations to check Link
    if ( ((rx_status_reg >> 1) & 0x1) &&  
         !((rx_status_reg >> 6) & 0x1) &&
         ((rx_block_lock & 0xFFFFF) == 0xFFFFF) &&
         ((rx_lane_synq  & 0xFFFFF) == 0xFFFFF) &&
         ((rx_lane_synq_err& 0xFFFFF) == 0)
      ){
      link_detected = 1;
    }
    printf("\n");
    printf("        Link detected                            : " BOOL_FMT(link_detected & 0x1));
    printf("\n");
  }

  // Unmap device
  if (unmap_fpga_axi4lite_device() != 0){
    printf("Error unmapping device\n");
    return -1;
  }
  return 0;

}
