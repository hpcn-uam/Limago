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
#include <stdint.h>
#include <locale.h>

#include "performance_debug.h"
#include "../common/common_functions.h"


void usage(void) {
    printf("\nThis program reads debug statistics :\n");
    printf("     -h       : It shows help\n");
    printf("     -a       : Address of the slave\n");
    printf("     -p <val> : Shows statistics of a particular port\n");
    printf("     -g <val> : Shows statistics of a range of ports starting from <val>\n");
    printf("     -r       : Reset statistics\n");
    printf("\n");
}

void read_show_statistics (uint32_t base_address, uint32_t port, long double period, int show_anyway){

    uint64_t      measured_cycles;
    uint64_t      measured_bytes;
    uint64_t      pkts_received;
    long double   bandwidth;

      // Read the 6 first elements
    measured_cycles = read_two_words(base_address, (port * 24)      );
    measured_bytes  = read_two_words(base_address, (port * 24) +  8 );
    pkts_received   = read_two_words(base_address, (port * 24) + 16 );

    if (measured_cycles != 0 || (show_anyway==1)){
      
      bandwidth = (measured_bytes / ((long double) (period * measured_cycles)))* 8.0;
      
      printf("******************** Stage %2d *********************\n",(int)(port) );

      printf("---------------------------------------------------\n");
      printf("| Packets that went through: %'20lu |\n", pkts_received);
      printf("| Bytes that went through  : %'20lu |\n", measured_bytes);
      printf("| Measured time            : %'16.3Lf  ms |\n", (long double) (period * measured_cycles)/1000000.0);
      printf("---------------------------------------------------\n");
      printf("|             Bandwidth: %6.3Lf Gb/s              |\n",bandwidth);
      printf("---------------------------------------------------\n");

    }

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
  uint32_t base_address;
  int      base_address_provided=0;
  int      error = 0;
  int      read_specific_port = -1;
  int      reset_statistics = -1;

  uint32_t  number_port;
  uint32_t  debug_name;
  uint32_t  clock_frequency;

  long double period;
  int i;
  int startPort=0;
  


  if (argc > 1 ) {
    /* Parse command line arguements */
    while((opt = getopt(argc, argv, "a:p:g:rh")) != EOF) {
      switch(opt) {
        case 'a':
          base_address = etoi(optarg);      // convert any input format to a unique format
          if (base_address % 4 !=0) {
            printf("base_address is not 32-bits aligned\n");
            return -1;
          }
          base_address_provided = 1;
          break;
        case 'h':
          usage();
          return 0;
        case 'p':
          read_specific_port = (uint32_t) atoi(optarg);
          break;  
        case 'g':
          startPort = (uint32_t) atoi(optarg);
          break;  
        case 'r':
          reset_statistics = 1;
          break;  
         default:
          printf("invalid option: %c\n", (char)opt);
          usage();
          return -1;
      }
    }
  }
  else{
    error = 1;
  }


  if ((base_address_provided == 0) || (error == 1)){
      printf("Error, you must enter the base address of the debug module\n");
      usage();
      return -1;
  }

  // Map the device 
  if (map_fpga_axi4lite_device() != 0){
    printf("Error mapping device\n");
    return -1;
  }


  debug_name = readWord(base_address, PERFORMANCE_DEBUG_NAME);
  setlocale(LC_NUMERIC, "");
  printf("***************************************************\n");
  printf("******* Debug Statistics Address 0x%06X *********\n", (base_address & 0xFFFFF));

  if ( debug_name == 0xADACED){
    number_port     = readWord(base_address, PERFORMANCE_DEBUG_NUMBER_PORTS         );
    clock_frequency = readWord(base_address, PERFORMANCE_DEBUG_CLOCK_FREQUENCY      );
    period = (long double) (1/((long double) clock_frequency))*1000000000.0;            // move it to nanoseconds

    if (read_specific_port >= 0){
      if ( read_specific_port < ((int) number_port)){
        writeWord (base_address , PERFORMANCE_DEBUG_HOLD_VALUES, read_specific_port);   // Hold statistics to read consistent data
        read_show_statistics(base_address, read_specific_port ,period, 1);
      }
      else {
        printf("Error you are trying to read the port %d which is a non valid port, the design has %d port(s) to debug\n",read_specific_port,  number_port);
        error = 1;
      }
    }
    else{
      printf("The design has %2d port(s).\nOnly those with data are shown. Starting from P: %2u\n",number_port,startPort);
      writeWord (base_address , PERFORMANCE_DEBUG_HOLD_VALUES, 0x3F);   // Hold statistics to read consistent data
      for (i = startPort; i < number_port ; i++){
        read_show_statistics(base_address,i,period,0);
      }
    }
    writeWord (base_address , PERFORMANCE_DEBUG_HOLD_VALUES,  0); // Release statistics

  }
  else {  // basic version
    period = 3.103; // Define clock period
    
    for (i=0 ; i < 4 ; i++){
      read_show_statistics(base_address,i,period,0);
    }
    
    printf("---------------------------------------------------\n");

  }


  if (reset_statistics == 1){
    printf("The debug statistics are going to be reseted\n");
    writeWord (base_address, 0 , 0x1);   // Reset that debug element
  }


  // Unmap device
  if (unmap_fpga_axi4lite_device() != 0){
    printf("Error unmapping device\n");
    return -1;
  }


  return error;
}
