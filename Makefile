#Makefile by Matheus Souza (github.com/mfbsouza)

### Config ###

# Project name
NAME := firmware

# directory structure
SRCDIR := src
BUILDDIR:= build
BINDIR := bin
SRCEXT := c
SOURCES := $(shell find $(SRCDIR) -type f -name *.$(SRCEXT))
OBJETCS := $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(SOURCES:.$(SRCEXT)=.o))

# Microcontroller Settings
MCU := atmega328p
F_CPU := 16000000

# Command line arguments
PROGRAMMER := arduino
PORT := /dev/ttyUSB0

# Compiler & Linker
CC := avr-gcc
LINKER := avr-gcc
CFLAGS := -std=c99 -Wall -g -Os -mmcu=${MCU}
LIB := -L lib
INC := -I include

# Compiling
$(BUILDDIR)/%.o: $(SRCDIR)/%.$(SRCEXT)
	@mkdir -p $(BUILDDIR)
	@echo " $(CC) $(CFLAGS) $(INC) -c $< -o $@"; $(CC) $(CFLAGS) $(INC) -c $< -o $@

# Linking
$(BINDIR)/$(NAME): $(OBJETCS)
	@echo " Linking..."
	@mkdir -p $(BINDIR)
	@echo " $(LINKER) -mmcu=${MCU} $(LIB) $^ -o $(BINDIR)/$(NAME).elf"; $(LINKER) -mmcu=${MCU} $(LIB) $^ -o $(BINDIR)/$(NAME).elf

objcopy:
	@echo " converting GNU executable file to Intel Hex file"
	@echo " avr-objcopy -O ihex -j .text -j .data $(BINDIR)/$(NAME).elf $(BINDIR)/$(NAME).hex"; avr-objcopy -O ihex -j .text -j .data $(BINDIR)/$(NAME).elf $(BINDIR)/$(NAME).hex 

# TODO: implement for a generic scenario
flash:
	@echo " flashing firmware to AVR chip"
	@echo " avrdude -v -p ${MCU} -c ${PROGRAMMER} -P ${PORT} -U flash:w:$(BINDIR)/$(NAME).hex"; avrdude -v -p ${MCU} -c ${PROGRAMMER} -P ${PORT} -U flash:w:$(BINDIR)/$(NAME).hex

clean:
	@echo " Cleaning...";
	@echo " $(RM) -r $(BUILDDIR)/* $(BINDIR)/*"; $(RM) -r $(BUILDDIR)/* $(BINDIR)/*

.PHONY: objcopy flash clean