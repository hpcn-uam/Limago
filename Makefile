# Define the default rule. Make all, create ips, projects and implement them
all: ips projects


# Before any other command, we need to define a phony target (create the project dir)
.PHONY:create_project_dir
create_project_dir:
	mkdir -p projects

#Get projects from scripts folders
scripts_folder = $(shell ls scripts/)
#Remove common_scripts folder because is not a project 
projects_list = $(filter-out common_scripts, $(scripts_folder))

# Generate the IPs will just invoke an external makefile
ips:
	make -C submodules/

projects_list : $(projects_list)

proj_prefix=create_prj_
impl_prefix=implement_prj_
backup_prefix=backup_bd_

#################################
### Creation of project targets #
#################################
## Creating a project involves generating the IPs, the project and implementing the previous design

$(proj_prefix)%: current_objective=$(subst $(proj_prefix),,$@)
$(proj_prefix)%: ips
	#rm -rf project/$(current_objective)
	vivado -notrace -mode batch -source scripts/common_scripts/create_project.tcl -tclargs $(current_objective)
	#find project/$(current_objective) -iname "types.svh" -print  -exec cp src/rtl/cmac/types.svh {} \;

#######################################
### Implementation of project targets #
#######################################
$(impl_prefix)% : current_objective=$(subst $(impl_prefix),,$@)
$(impl_prefix)% : 
	vivado -notrace -mode batch -source scripts/common_scripts/implement_project.tcl -tclargs $(current_objective)

#######################################
### Backup of the changes in a BD     #
#######################################

$(backup_prefix)%: current_objective=$(subst $(backup_prefix),,$@)
$(backup_prefix)%:
	vivado -notrace -mode batch -source scripts/common_scripts/backup_block_design.tcl -tclargs $(current_objective)


.PHONY: list help
list:
	@(make -rpn | sed -n -e '/^$$/ { n ; /^[^ .#][^% ]*:/p ; }' | sort | egrep --color '^[^ ]*:' )

help:
	@echo "Different projects can be created from this Makefile. So be patient and study the different possibilities before getting hands into the project."
	@echo ""
	@echo "The basic starting point is getting used to the defined targets. They can be stated with the command:"
	@echo -e "    \e[94mmake list\e[39m"
	@echo ""
	@echo "The basic usage of this makefile is:"
	@echo -e " 0) \e[94mmake all\e[39m"
	@echo ""
	@echo "Alternatively you can specify a subset of the output rules. For instance:"
	@echo ""
	@echo -e " 1) \e[100mCreate the IPs\e[49m for the project"
	@echo -e "    \e[94mmake ips\e[39m"
	@echo -e " 2) \e[100mCreate a particular project.\e[49m" 
	@echo -e "    It has two parts: first, create the project - refer to \e[100m2*\e[49m; second, implement the project - refer to \e[100m2**\e[49m"
	@echo " 2*) If you are just interested in the creation of a particular project, you can just type one of the following targets:"
	@echo -e "    \e[94mmake $(addprefix $(proj_prefix), $(projects_list))\e[39m"
	@echo " 2**) If you are exclusively interested in the implementation of a particular project, you just need to execute:"
	@echo -e "    \e[94mmake $(addprefix $(impl_prefix), $(projects_list))\e[39m"
	@echo " 3) Backup block design:"
	@echo -e "    \e[94mmake $(addprefix $(backup_prefix), $(projects_list))\e[39m"
	@echo ""
	@echo "Remember that you can always review this help with"
	@echo -e "    \e[94mmake help\e[39m"


clean:
	rm -rf *.log *.jou *.bak synlog.tcl *.str .Xil fsm_encoding.os webtalk* vivado*.zip
	make clean -C submodules/

distclean: clean
	make distclean -C submodules/
	rm -rf $(shell pwd)/projects
