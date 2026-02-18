FILES		:= ./rtl/controller.sv ./rtl/datapath.sv ./rtl/ntermo.sv
OBJS		:=  $(FILES:.sv=.svo)

COMP_FLAGS	:= -uvm 2020.3.1 -lib work -sv2017 +acc+b
SEED		?= 1
SIM_FLAGS	:= -uvm 2020.3.1 -top work.tb +acc+b +UVM_NO_RELNOTES \
			   -waves ntermo.vcd -timescale 1ns/100ps -write-sql  \
			   -sv_seed $(SEED)

.PHONY: all
all: sim

sim: $(OBJS)
	dsim $(SIM_FLAGS)

.PHONY: clean
clean:
	rm -frd ./dsim_work ./dsim.env ./dsim.log ./dvlcom.env ./dvlcom.log
	rm -frd ./metrics.db ./ntermo.vcd $(OBJS)

### COMPILE RULES

%.svo:%.sv
	dvlcom $(COMP_FLAGS) $<
	@touch $@
