OBJDIR=$(TOPDIR)/ip/

.PHONY: all
all: ip/cuckoo_cam/component.xml

ip/cuckoo_cam/component.xml: 
	vivado -notrace -mode batch -source wrap_cuckoo.tcl

clean:
	rm *.jou *.log

distclean: clean
	rm -rf ip/

