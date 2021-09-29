MATLABDIRS = libncs_matlab
OMNETDIRS = inet matlab-scheduler libncs_omnet ncs-testbench
ALLDIRS = $(MATLABDIRS) $(OMNETDIRS)
MAKECONF = makeconf

.DEFAULT_GOAL := all
.PHONY: $(MAKECONF) all clean cleanall makefiles checkmakefiles $(ALLDIRS) $(addprefix clean-,$(ALLDIRS)) $(addprefix cleanall-,$(ALLDIRS)) $(addprefix checkmakefiles-,$(OMNETDIRS)) $(addprefix makefiles-,$(OMNETDIRS))

#
# manage flag persistence
#
ENV_MODE ::= $(MODE)
ENV_OPENMP ::= $(OPENMP)
ENV_WITH_ASAN ::= $(WITH_ASAN)
REWRITE_MAKECONF = 0

ifneq (,$(wildcard $(MAKECONF)))
include $(MAKECONF)
endif

ifneq ($(strip $(ENV_MODE)),)
	MODE ::= $(ENV_MODE)
	REWRITE_MAKECONF = 1
endif
ifneq ($(strip $(ENV_OPENMP)),)
	OPENMP ::= $(ENV_OPENMP)
	REWRITE_MAKECONF = 1
endif
ifneq ($(strip $(ENV_WITH_ASAN)),)
	WITH_ASAN ::= $(ENV_WITH_ASAN)
	REWRITE_MAKECONF = 1
endif

# export flags
export MODE
export OPENMP # set OPENMP=0, in case we do not wish to use mex files compiled with openmp enabled
export WITH_ASAN # set WITH_ASAN=1 to compile with AddressSanitizer to search for memory errors

# special target to persist flags
$(MAKECONF):
ifeq (1,$(REWRITE_MAKECONF))
		$(file >$(MAKECONF),)
ifneq ($(strip $(MODE)),)
		$(file >>$(MAKECONF),MODE=$(MODE))
endif
ifneq ($(strip $(OPENMP)),)
		$(file >>$(MAKECONF),OPENMP=$(OPENMP))
endif
ifneq ($(strip $(ENV_WITH_ASAN)),)
		$(file >>$(MAKECONF),WITH_ASAN=$(WITH_ASAN))
endif
endif

#
# regular targets
#

all: ncs-testbench

ncs-testbench: $(MATLABDIRS) $(OMNETDIRS)

libncs_omnet: inet libncs_matlab

$(ALLDIRS): %: checkmakefiles-% $(MAKECONF)
	+$(MAKE) -C $@ all

clean: $(addprefix clean-,$(ALLDIRS))

$(addprefix clean-,$(ALLDIRS)): clean-%: checkmakefiles-%
	+$(MAKE) -C $(subst clean-,,$@) clean

cleanall: $(addprefix cleanall-,$(ALLDIRS))

$(addprefix cleanall-,$(ALLDIRS)): cleanall-%: checkmakefiles-%
	+$(MAKE) -C $(subst cleanall-,,$@) cleanall

checkmakefiles: $(addprefix checkmakefiles-,$(OMNETDIRS))

$(addprefix checkmakefiles-,$(OMNETDIRS)):
	@+$(MAKE) -C $(subst checkmakefiles-,,$@) checkmakefiles

$(addprefix checkmakefiles-,$(MATLABDIRS)):
	#dummy target to simplify makefile

makefiles: $(addprefix makefiles-,$(OMNETDIRS))

$(addprefix makefiles-,$(OMNETDIRS)):
	@+$(MAKE) -C $(subst makefiles-,,$@) makefiles

