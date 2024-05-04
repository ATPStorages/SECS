.POSIX:
.PHONY: clean run run-img

SOURCE_DIR      := ./Source
SOURCE_MAIN_DIR := $(SOURCE_DIR)/Main
OTHERS_DIR      := $(SOURCE_DIR)/Others
BUILD_DIR       := ./Build
RTS_BUILD_DIR   := $(BUILD_DIR)/RTS

GNAT_GCC_OPTS     := -c -m32 -Os -Wall -Wextra
GNAT_GCC_OPTS_EXT := -gnatp
GNAT_GCC_OPTS_RTS := -gnatg

SOURCES := $(patsubst %.adb,%,$(shell find $(SOURCE_MAIN_DIR) -name '*.asm' -or -name '*.adb'))
OBJECTS := $(SOURCES:%=$(BUILD_DIR)/%.o) 

SOURCES_RTS := $(patsubst %.adb,%,$(shell find $(OTHERS_DIR)/ada-rts -name '*.asm' -or -name '*.adb'))
OBJECTS_RTS := $(SOURCES_RTS:%=$(RTS_BUILD_DIR)/%.o)

$(BUILD_DIR)/%.o: %.adb
	mkdir -p $(dir $@)
	gnatgcc $(GNAT_GCC_OPTS_EXT) $(GNAT_GCC_OPTS) -o $@ $<

$(RTS_BUILD_DIR)/%.o: %.adb
	mkdir -p $(dir $@)
	gnatgcc $(GNAT_GCC_OPTS_EXT) $(GNAT_GCC_OPTS) $(GNAT_GCC_OPTS_RTS) -o $@ $<

$(BUILD_DIR)/%.asm.o: %.asm
	mkdir -p $(dir $@)
	nasm -f elf32 $< -o $@

$(BUILD_DIR)/main.elf: $(OBJECTS) $(OBJECTS_RTS)
	ld -m elf_i386 -T linker.ld -o $@ $^

main.img: $(BUILD_DIR)/main.elf
	cp '$<' iso/boot
	grub-mkrescue -o $@ iso

#############################################

$(BUILD_DIR)/efi_main.o: main.c
	gcc $^                                      \
		-c                                  \
		-fno-stack-protector                 \
		-fpic                               \
		-fshort-wchar                       \
		-mno-red-zone                       \
		-I $(OTHERS_DIR)/gnu-efi/inc        \
		-I $(OTHERS_DIR)/gnu-efi/inc/x86_64 \
		-DEFI_FUNCTION_WRAPPER              \
		-o $@

$(BUILD_DIR)/efi_main.so: $(BUILD_DIR)/efi_main.o
	ld $^                                                         \
		$(OTHERS_DIR)/gnu-efi/x86_64/gnuefi/crt0-efi-x86_64.o \
		-nostdlib                                             \
		-znocombreloc                                         \
		-T $(OTHERS_DIR)/gnu-efi/gnuefi/elf_x86_64_efi.lds    \
		-shared                                               \
		-Bsymbolic                                            \
		-L $(OTHERS_DIR)/gnu-efi/x86_64/gnuefi                \
		-L $(OTHERS_DIR)/gnu-efi/x86_64/lib                   \
		-l:libgnuefi.a                                        \
		-l:libefi.a                                           \
		-o $@

$(BUILD_DIR)/main.efi: $(BUILD_DIR)/efi_main.so
	objcopy -j .text                \
		-j .sdata               \
		-j .data                \
		-j .dynamic             \
		-j .dynsym              \
		-j .rel                 \
		-j .rela                \
		-j .reloc               \
		--target=efi-app-x86_64 \
		$^                      \
		$@

efi_disk.img: $(BUILD_DIR)/main.efi
	dd if=/dev/zero of=$@ bs=512 count=93750
	parted $@ -s -a minimal mklabel gpt
	parted $@ -s -a minimal mkpart EFI FAT16 2048s 93716s
	parted $@ -s -a minimal toggle 1 boot
	
	dd if=/dev/zero of=/tmp/part.img bs=512 count=91669
	mformat -i /tmp/part.img -h 32 -t 32 -n 64 -c 1
	
	mcopy -i /tmp/part.img $^ ::

	dd if=/tmp/part.img of=$@ bs=512 count=91669 seek=2048 conv=notrunc

#############################################

# Commands
clean:
	rm -rf *.img *.ali $(BUILD_DIR)/*

run-efi: efi_disk.img
	qemu-system-x86_64 -cpu qemu64 -bios OVMF.fd -drive file=$^,if=ide -net none

run: $(BUILD_DIR)/main.elf
	qemu-system-i386 -cpu qemu32-v1 -smp 1 -kernel '$<'

recomp:
	$(MAKE) clean
	$(MAKE) run

run-img: main.img
	qemu-system-i386 -hda '$<' -net none