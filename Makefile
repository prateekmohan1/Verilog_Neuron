
#####Using Makefile#######
## make <comp|run_wave> MODULE_NAME=<module name without the .sv>

######Verilog Compiler######

COMPILER := iverilog

VCDCREATE := vvp

WAVEVIEW := gtkwave


######Find all .sv Verilog Files, Ignore testbenches######

ALLVFILES := $(filter-out $(wildcard *_tb.sv), $(wildcard *.sv))

######Compiling Code######
.PHONY: comp

comp: $(MODULE_NAME).comp

$(MODULE_NAME).comp : $(MODULE_NAME)_tb.sv $(ALLVFILES)
	$(COMPILER) -g2009 -o $(MODULE_NAME).comp $(MODULE_NAME)_tb.sv $(ALLVFILES)

######Creating Wave######
.PHONY: run_wave

run_wave : $(MODULE_NAME).vcd

$(MODULE_NAME).vcd : $(MODULE_NAME).comp 
	$(VCDCREATE) $(MODULE_NAME).comp
	##$(WAVEVIEW) $(MODULE_NAME).vcd &

clean: 
	rm *.vcd *.comp
