##
# ZincOS
#
# @file
# @version 0.1
SRCDIR := src
BUILDDIR := bin

ASM = $${HOME}/opt/cross/bin/i686-elf-as
CC = $${HOME}/opt/cross/bin/i686-elf-gcc
LDS = ${SRCDIR}/linker.ld

CFLAGS = -ffreestanding -O2 -Wall -Wextra
LDFLAGS = -T ${LDS} -ffreestanding -O2 -nostdlib -lgcc

C_SRC = $(wildcard ${SRCDIR}/*.c)
ASM_SRC = $(wildcard ${SRCDIR}/*.S)
OBJ = ${C_SRC:.c=.o} ${ASM_SRC:.S=.o}

all: options ${OBJ} link

options:
	@echo ZincOS build options:
	@echo "CFLAGS = ${CFLAGS}"
	@echo "LDFLAGS = ${LDFLAGS}"

%.o: %.c
	@echo !===== COMPILING $^
	${CC} -c $< -o $@ -std=gnu99 $(CFLAGS)

%.o: %.S
	@echo !===== ASSEMBLING $^
	${ASM} $< -o $@

link: ${OBJ}
	@echo !===== LINKING $^
	${CC} ${LDFLAGS} -o ${BUILDDIR}/zinc_os.bin $^

run:
	qemu-system-i386 -kernel ${BUILDDIR}/zinc_os.bin

clean:
	rm -f ${OBJ} ${BUILDDIR}/zinc_os.bin

.PHONY: all link clean
# end
