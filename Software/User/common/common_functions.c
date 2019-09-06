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

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <byteswap.h>
#include <string.h>
#include <errno.h>
#include <signal.h>
#include <fcntl.h>
#include <ctype.h>
#include <termios.h>

#include <sys/types.h>
#include <sys/mman.h>

#include "common_functions.h"

#define FATAL do { fprintf(stderr, "Error at line %d, file %s (%d) [%s]\n", __LINE__, __FILE__, errno, strerror(errno)); exit(1); } while(0)

#define MAP_SIZE (128*1024UL)
#define MAP_MASK (MAP_SIZE - 1)

/* ltoh: little to host */
/* htol: little to host */
#if __BYTE_ORDER == __LITTLE_ENDIAN
#  define ltohl(x)       (x)
#  define ltohs(x)       (x)
#  define htoll(x)       (x)
#  define htols(x)       (x)
#elif __BYTE_ORDER == __BIG_ENDIAN
#  define ltohl(x)     __bswap_32(x)
#  define ltohs(x)     __bswap_16(x)
#  define htoll(x)     __bswap_32(x)
#  define htols(x)     __bswap_16(x)
#endif

const char device_char[200] = "/dev/xdma0_user";

/** 
* @brief This function can parse a string to an unsigned integer. Supported formats are:
* 12345678    : Number in base 10.
* 0x12345678  : Number in base 16.
* x12345678   : Number in base 16. Omit the initial 0 .
* 0x1234_5678 : Number in base 16. In order to avoid errors, '-' or '_' can be used as separators
* x1234_5678  : Number in base 16. In order to avoid errors, '-' or '_' can be used as separators
* 0x1234-5678 : Number in base 16. In order to avoid errors, '-' or '_' can be used as separators
* x1234-5678  : Number in base 16. In order to avoid errors, '-' or '_' can be used as separators
*
* @param string The string that is going to be parsed
*
* @return The 32 bits value as an integer
*/
uint32_t etoi(char* string) { // 'Everything to int'
  int length;
  int i;
  char *value;
  char next_condition = 0;

  ////
  // Is this an hexadecimal value?  0x.... or x...
  if((value=strchr(string,'x'))||(value=strchr(string,'X'))) { 
    value++;
    if((value-string)>2) { // 213123x3342342 -> Invalid number. Support 0x1234 or x1234
      return -1;
    }
    if(value-string==2 && string[0]!='0') { // 2x34243
      return -1;
    }
    length =  strlen(value);
    // Check for a number of the style 0x12345678...90
    for(i=0;i<length;i++) {
      switch(value[i]) {
        case '0':case '1': 
        case '2': case '3': 
        case '4': case '5': 
        case '6': case '7': 
        case '8': case '9': 
        case 'a': case 'A': 
        case 'b': case 'B': 
        case 'c': case 'C': 
        case 'd': case 'D': 
        case 'e': case 'E': 
        case 'f': case 'F': break;
        default: next_condition = 1;
      }
      if(next_condition) {
        break;
      }
      if(i==length-1) { 
        return strtol(value, NULL, 16);
      }
    }
    // Check for a number of the style 0x1234_5678_...90
    uint32_t cdword  = 0;
    uint32_t tdword  = 0;
    uint32_t multp  = 1;
    uint32_t multd  = 1;
    char cnt,cchar;
    for(i=length-1;i>=0;i--) {

      if(cnt%4==0 && cnt!=0) {
        if(value[i]!='_'&&value[i]!='-') {
          break;
        }
        tdword += multd*cdword;
        multd*=(65536); // 16**4
        multp = 1;
        cdword = 0;
        cnt=0;
      } else {
        cnt++;
        switch(value[i]) {
          case '0': cchar = 0;  break;
          case '1': cchar = 1;  break;
          case '2': cchar = 2;  break;
          case '3': cchar = 3;  break;
          case '4': cchar = 4;  break;
          case '5': cchar = 5;  break;
          case '6': cchar = 6;  break;
          case '7': cchar = 7;  break;
          case '8': cchar = 8;  break;
          case '9': cchar = 9;  break;
          case 'a': case 'A':  cchar = 10;  break;
          case 'b': case 'B':  cchar = 11;  break;
          case 'c': case 'C':  cchar = 12;  break;
          case 'd': case 'D':  cchar = 13;  break;
          case 'e': case 'E':  cchar = 14;  break;
          case 'f': case 'F':  cchar = 15;  break;
          default: return -1;
        }
        cdword += cchar * multp;
        multp*=16;
      }
      if(i==0) { 
        return tdword + multd*cdword;
      }
    }
  
  ////
  //This is not an hexadecimal value. Check for digits and use atoi.
  } else {
    length=strlen(string);
    // Check for an integer. Contemplate things such as 123213a34
    for(i=0;i<length;i++) {
      if(!isdigit(string[i])) {
        return -1;
      }
    }
    return atoi(string);
  }

  return -1;
}


static void *map_base;                  // Pointer to memory where the device is mapped
static int fd;                          // Pointer to device

int map_fpga_axi4lite_device (void) {

  if ((fd = open(device_char, O_RDWR | O_SYNC)) == -1) FATAL;
#ifdef DEBUG
  printf("character device %s opened.\n", device_char); 
#endif
  fflush(stdout);

  /* map one page */
  map_base = mmap(0, MAP_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
  if (map_base == (void *) -1) FATAL;
#ifdef DEBUG  
  printf("Memory mapped at address %p.\n", map_base); 
#endif
  fflush(stdout);

  return 0;
}

int unmap_fpga_axi4lite_device (void) {
  if (munmap(map_base, MAP_SIZE) == -1) FATAL;
  close(fd);
  return 0;
}


uint32_t readWord (uint32_t base_addr, uint32_t offset){
  void      *virt_addr;
  uint32_t  read_result,read_result1;

  virt_addr = map_base + base_addr + offset;        // Compute virtual address
  
  read_result = (*((uint32_t *) virt_addr));
  read_result1 = ltohs(read_result);

#ifdef DEBUG 
  printf("Read from physical address %08X, virtual address %p \n",(unsigned int) (base_addr + offset), virt_addr);
  printf("Read data %08X,data after endianess check %08x\n", (unsigned int) read_result, (unsigned int) read_result1);
#endif  

  return read_result1;               // Return read value
}

void writeWord (uint32_t base_addr, uint32_t offset, uint32_t value){
  void      *virt_addr;
  uint32_t   writeval;
  
  virt_addr = map_base + base_addr + offset;    // Compute virtual address
  writeval = htoll(value);                      // Check endianess

#ifdef DEBUG 
  printf("Write to physical address %08X, virtual address %p \n",(unsigned int) (base_addr + offset), virt_addr);
  printf("Data to write %08X, write data after endianess check %08X\n", (unsigned int) value, (unsigned int) writeval);
#endif  

  *((uint32_t *) virt_addr) = writeval;         // Write value
}


uint32_t parseIPV4string(char* ipAddress) {

  uint32_t ip_aux;
  uint32_t a,b,c,d;

  sscanf(ipAddress, "%d.%d.%d.%d", &a, &b, &c, &d);

  ip_aux = (((uint32_t) a) << 24) + (((uint32_t) b) << 16) + 
          (((uint32_t) c) << 8) + ((uint32_t) d);

  return ip_aux;
}

uint64_t read_two_words(uint32_t base_addr, uint32_t offset) {

  uint32_t tmp,tmp1;
  uint64_t aux;

  tmp  = readWord (base_addr , offset );
  tmp1 = readWord (base_addr , offset+4);
  aux = ((( (uint64_t) tmp1 << 32) & 0xFFFFFFFF00000000) + (tmp & 0xFFFFFFFF));

  return aux;
  
#ifdef DEBUG 
  printf("Addr %X\ttmp1: %lu\ttmp: %lu %llu\n", base_addr + offset,tmp1,tmp, (long long unsigned) aux);
#endif
}