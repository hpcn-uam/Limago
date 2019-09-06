all:
	make -C cmac/
	make -C fpga-network-stack-core/
	make -C cuckooCam/

#### The rules below applies for clean and distclean
%:
	make -C cmac/ $@	
	make -C fpga-network-stack-core/ $@
	make -C cuckooCam/ $@

