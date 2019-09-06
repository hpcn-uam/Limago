CC=gcc
CPLUS=g++

# The list of the executables that will be generated.

EXEC1=cmac_stats
EXEC2=performance_debug
EXEC3=hw_iperf2
EXEC4=toe_stats

#Use _GNU_SOURCE for O_DIRECT flag
CXXFLAGS += -Wall -D_GNU_SOURCE
COPTFLAGS =  # -O3

SRC = User/common/common_functions.c #List of all .c of the user example.
INC = User/common/common_functions.h  #List of all .h
OBJ = $(SRC:.c=.o)

SRC1 = User/cmac_statistics/cmac_statistics.c
OBJ1 = $(SRC1:.c=.o)
LINKER_FLAGS1= -o ./bin/$(EXEC1)

SRC2 = User/performance_debug/performance_debug.c
OBJ2 = $(SRC2:.c=.o)
LINKER_FLAGS2= -o ./bin/$(EXEC2)

SRC3 = User/iperf2/iperf2.c
OBJ3 = $(SRC3:.c=.o)
LINKER_FLAGS3= -o ./bin/$(EXEC3)

SRC4 = User/toe_statistics/toe_statistics.c
OBJ4 = $(SRC4:.c=.o)
LINKER_FLAGS4= -o ./bin/$(EXEC4)


all: driver rwCmac performance_debug hw_iperf2 toe_stats

.PHONY: create_bin


create_bin:
	@mkdir -p bin

rwCmac: create_bin $(OBJ1)  $(OBJ)  Makefile
	$(CC) $(CFLAGS) $(OBJ1)  $(OBJ) $(LINKER_FLAGS1)	

performance_debug: create_bin $(OBJ2) $(OBJ)  Makefile
	$(CC) $(CFLAGS) $(OBJ2)  $(OBJ) $(LINKER_FLAGS2)

hw_iperf2: create_bin $(OBJ3) $(OBJ)  Makefile
	$(CC) $(CFLAGS) $(OBJ3)  $(OBJ) $(LINKER_FLAGS3)

toe_stats: create_bin $(OBJ4) $(OBJ)  Makefile
	$(CC) $(CFLAGS) $(OBJ4)  $(OBJ) $(LINKER_FLAGS4)		

mem_perf: create_bin $(OBJ5) $(OBJ)  Makefile
	$(CC) $(CFLAGS) $(OBJ5)  $(OBJ) $(LINKER_FLAGS5)		

$(OBJ): %.o : %.c $(INC) 
	$(CC) -c $(CXXFLAGS) $< -o $@

$(OBJ1): %.o : %.c $(INC) 
	$(CC) -c $(CXXFLAGS) $(COPTFLAGS)  $< -o $@

$(OBJ2): %.o : %.c $(INC) 
	$(CC) -c $(CXXFLAGS) $(COPTFLAGS)  $< -o $@	

$(OBJ3): %.o : %.c $(INC) 
	$(CC) -c $(CXXFLAGS) $(COPTFLAGS)  $< -o $@	

$(OBJ4): %.o : %.c $(INC) 
	$(CC) -c $(CXXFLAGS) $(COPTFLAGS)  $< -o $@	


.PHONY: driver

driver: create_bin
	@cd Xilinx_DMA_Driver/xdma/; make; cp *.ko ../../bin/
	@cd Xilinx_DMA_Driver/tools; make; cp reg_rw ../../bin/
	
clean:
	@cd Xilinx_DMA_Driver/xdma; make clean
	@cd Xilinx_DMA_Driver/tools; make clean
	@find . -name "*.o" -type f -delete
	@rm -f *~ */*~

distclean: clean
	@rm -rf bin	


ARCHIVE_PREFIX=xdma_driver_user
ARCHIVE_SUFFIX=$(shell date "+%Y_%m_%d")
ARCHIVE=$(ARCHIVE_PREFIX)-$(ARCHIVE_SUFFIX)

zip: distclean
	@zip -r $(ARCHIVE).zip .

.PHONY: help

help:
	@echo "-------------------------------------------------------------------------------------------------"
	@echo "This makefile supports the following options:"
	@echo "-------------------------------------------------------------------------------------------------"
	@echo "     + make all: Generates user and driver design under the bin path."
	@echo "     + make clean: Removes user and driver design."
	@echo "     + make zip: Creates a .zip file with the current directory files."
	@echo "--------------------------------------------------------------------Mario Daniel Ruiz Noguera----"
