# Makefile for SystemVerilog Project

# Define the simulator to be used
SIMULATOR = iverilog
SIM_FLAGS = -g2012

# Define source and testbench directories
SRC_DIR = src
TB_DIR = $(SRC_DIR)/testbench
MOD_DIR = $(SRC_DIR)/modules

# Define source files
SRC_FILES = $(MOD_DIR)/module1.sv $(MOD_DIR)/module2.sv $(SRC_DIR)/top.sv

# Define testbench files
TB_FILES = $(TB_DIR)/tb_top.sv $(TB_DIR)/tb_utils.sv

# Define output files
OUTPUT = sim_output

# Default target
all: compile simulate

# Compile the design and testbench
compile:
	$(SIMULATOR) $(SIM_FLAGS) -o $(OUTPUT) $(SRC_FILES) $(TB_FILES)

# Run the simulation
simulate:
	./$(OUTPUT)

# Clean up generated files
clean:
	rm -f $(OUTPUT) *.vcd

# Phony targets
.PHONY: all compile simulate clean