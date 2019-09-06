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

#include "iperf2.h"
#include "../common/common_functions.h"

#define BOOL_FMT(bool_expr) "%s", (bool_expr) ? "Yes" : "No "
#define CLOCK_FREQUENCY 322265624

void usage(void) {
    printf("You can use the following arguments:\n");
    printf("     -h : It shows help\n");
    printf("     -b <bytes> : Bytes to send\n");
    printf("     -c : Server address (e.g. W.X.Y.Z)\n");
    printf("     -d : Enable dual mode (both side send data)\n");
    printf("     -e : Run experiment\n");
    printf("     -i <0,1> : Selects interface, by default is interface 0\n");
    printf("     -m <MSS>   : Set Maximum Segment Size\n");
    printf("     -n <conn>  : Number of connections\n");
    printf("     -p <port>  : Starting port, the connection 0 will use <port> and the successive connections will increase by one \n");
    printf("     -r : Read registers\n");
    printf("     -s : Work as a server\n");
    printf("     -t <time>  : Run the experiment for <time> seconds, instead of sending N bytes\n");
    printf("If the programme is run without arguments, IPERF will be executed with default \n");
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


  int      opt;
  uint32_t run_experiment = 0;
  uint32_t dual_mode = 0;
  uint32_t num_conn = 1;
  uint32_t transfer_size = 100000;
  uint32_t packet_mss = 1460;
  uint32_t dual_mode_r;
  uint32_t num_conn_r;
  uint32_t transfer_size_r;
  uint32_t packet_mss_r;
  uint32_t ipDestination_r;
  uint32_t read_registers = 0;
  uint32_t ipDestination = 0xC0A80008;
  uint32_t dstPort = 5001;
  uint32_t run_as_server=0;
  
  uint32_t maxConnections = 1;
  uint32_t useTimer = 0;
  uint32_t userTimer = 0;
  uint32_t useTimer_r = 0;
  uint32_t dstPort_r = 0;

  double   clock_period = 1.0/(double)(CLOCK_FREQUENCY);
  uint64_t timerClockCycles;
  uint64_t timerClockCycles_r;
  uint32_t timerClockCycles_lsb_r,timerClockCycles_msb_r;
  uint32_t interface = 0x0;
  uint32_t interface_num = 0;
  uint32_t iperf2_tcp_base_addr;

  if (argc > 1 ) {
    /* Parse command line arguements */
    while((opt = getopt(argc, argv, "b:c:dehi:m:n:p:rst:")) != EOF) {
      switch(opt) {
        case 'b':
          transfer_size = etoi(optarg);       // convert any input format to a unique format
          break;
        case 'c':                             // Work as a client, read the IP to connect to
            ipDestination = parseIPV4string(optarg);
          break;          
        case 'd':
          dual_mode = 1;
          break;  
        case 'e':   // Run experiment
          run_experiment = 1; 
          break;  
        case 'h':
          usage();
          return 0;
        case 'i':
          interface_num = (uint32_t) atoi(optarg);
          if (interface_num == 0) {
            interface = 0x0;
          }
          else if (interface_num == 1) {
            interface = 0x10000;
          }
          else {
            printf("Error wrong interface number, valid values are 0 or 1\n");
            return -1;
          }
          break;  
        case 'm':
          packet_mss = etoi(optarg);            // convert any input format to a unique format 
          break;
        case 'n':
          num_conn = etoi(optarg);            // convert any input format to a unique format
          break;   
        case 'p':
          dstPort = etoi(optarg); // get the port
        case 'r':
          read_registers  = 1;
          break;
        case 's':   
          run_as_server = 1; 
          break;
        case 't':   // Set time
          useTimer = 1; 
          userTimer = etoi(optarg);;
          break;  
        default:
          printf("invalid option: %c\n", (char)opt);
          usage();
          return -1;
      }
    }
  }
  else {
    run_experiment = 1; 
    read_registers = 1;
  }


  // Map the device 
  if (map_fpga_axi4lite_device() != 0){
    printf("Error mapping device\n");
    return -1;
  }

  /* Take into account if the interface number */
  iperf2_tcp_base_addr      = XIPERF2_CLIENT_SETTINGS_BASE_ADDRESS + interface;

  /* Write Values */
  writeWord (iperf2_tcp_base_addr, XIPERF2_CLIENT_SETTINGS_ADDR_DUALMODEEN_V_DATA     , dual_mode);  
  writeWord (iperf2_tcp_base_addr, XIPERF2_CLIENT_SETTINGS_ADDR_NUMCONNECTIONS_V_DATA , num_conn);  
  writeWord (iperf2_tcp_base_addr, XIPERF2_CLIENT_SETTINGS_ADDR_TRANSFER_SIZE_V_DATA  , transfer_size);  
  writeWord (iperf2_tcp_base_addr, XIPERF2_CLIENT_SETTINGS_ADDR_PACKET_MSS_V_DATA     , packet_mss);  
  writeWord (iperf2_tcp_base_addr, XIPERF2_CLIENT_SETTINGS_ADDR_IPDESTINATION_V_DATA  , ipDestination);  
  writeWord (iperf2_tcp_base_addr, XIPERF2_CLIENT_SETTINGS_ADDR_USETIMER_V_DATA       , useTimer);  
  writeWord (iperf2_tcp_base_addr, XIPERF2_CLIENT_SETTINGS_ADDR_DSTPORT_V_DATA        , dstPort);  


  if (useTimer){
    timerClockCycles  = (userTimer/clock_period);
    writeWord (iperf2_tcp_base_addr, XIPERF2_CLIENT_SETTINGS_ADDR_RUNTIME_V_DATA        , timerClockCycles & 0xFFFFFFFF);  
    writeWord (iperf2_tcp_base_addr, XIPERF2_CLIENT_SETTINGS_ADDR_RUNTIME_V_DATA + 0x4  , (timerClockCycles >> 32) & 0xFFFFFFFF);  
  }

  if (read_registers == 1) {
    num_conn_r          = readWord(iperf2_tcp_base_addr, XIPERF2_CLIENT_SETTINGS_ADDR_NUMCONNECTIONS_V_DATA);
    dual_mode_r         = readWord(iperf2_tcp_base_addr, XIPERF2_CLIENT_SETTINGS_ADDR_DUALMODEEN_V_DATA);
    transfer_size_r     = readWord(iperf2_tcp_base_addr, XIPERF2_CLIENT_SETTINGS_ADDR_TRANSFER_SIZE_V_DATA);
    packet_mss_r        = readWord(iperf2_tcp_base_addr, XIPERF2_CLIENT_SETTINGS_ADDR_PACKET_MSS_V_DATA);
    ipDestination_r     = readWord(iperf2_tcp_base_addr, XIPERF2_CLIENT_SETTINGS_ADDR_IPDESTINATION_V_DATA);
    useTimer_r          = readWord(iperf2_tcp_base_addr, XIPERF2_CLIENT_SETTINGS_ADDR_USETIMER_V_DATA);
    dstPort_r           = readWord(iperf2_tcp_base_addr, XIPERF2_CLIENT_SETTINGS_ADDR_DSTPORT_V_DATA);
    maxConnections      = readWord(iperf2_tcp_base_addr, XIPERF2_CLIENT_SETTINGS_ADDR_MAXCONNECTIONS_V_DATA);
    timerClockCycles_lsb_r  = readWord(iperf2_tcp_base_addr, XIPERF2_CLIENT_SETTINGS_ADDR_RUNTIME_V_DATA);
    timerClockCycles_msb_r  = readWord(iperf2_tcp_base_addr, XIPERF2_CLIENT_SETTINGS_ADDR_RUNTIME_V_DATA + 0x4);
    timerClockCycles_r  = (((uint64_t) timerClockCycles_msb_r << 32) & 0xFFFFFFFF00000000) + timerClockCycles_lsb_r;
    /* Print Registers */
  
    printf(" -----------------------------------------\n");
    printf(" | IPERF2  Interface %1d Settings        |\n", interface_num);
    printf(" -----------------------------------------\n");
  
    printf(" |- Running connections   : %u \n", num_conn_r);
    printf(" |- Dual Mode             : " BOOL_FMT(dual_mode_r & 0x1));
    printf("\n |- Use timer             : " BOOL_FMT(useTimer_r & 0x1));
    if (useTimer_r & 0x1){
      printf("\n |- Running for           : %lu clock cycles", (long unsigned int) timerClockCycles_r);
    }
    else {
      printf("\n |- Transfer Size         : %u ", transfer_size_r);
    }
    printf("\n |- Packet MSS            : %d  \n", packet_mss_r);
    printf(" |- Destination IP        : %d.%d.%d.%d  \n", 
            ((ipDestination_r >> 24) & 0xFF),((ipDestination_r >> 16) & 0xFF),((ipDestination_r >> 8) & 0xFF),(ipDestination_r & 0xFF));
    printf(" |- Destination port      : %d  \n", dstPort_r);
    printf(" |- Maximum connections   : %u\n", maxConnections);
    printf(" -----------------------------------------\n\n");
  }

  if (run_experiment == 1){
    // Run experiment
    writeWord (iperf2_tcp_base_addr, XIPERF2_CLIENT_SETTINGS_ADDR_RUNEXPERIMENT_V_DATA  , 1);  
    // clear run experiment
    writeWord (iperf2_tcp_base_addr, XIPERF2_CLIENT_SETTINGS_ADDR_RUNEXPERIMENT_V_DATA  , 0);  
  }

  // Unmap device
  if (unmap_fpga_axi4lite_device() != 0){
    printf("Error unmapping device\n");
    return -1;
  }
  return 0;

}
