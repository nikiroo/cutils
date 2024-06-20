# Note: 99+ required for for-loop initial declaration (CentOS 6)
# Note: gnu99 (instead of c99) required for libcutils-net

CFLAGS   += -Wall -pedantic -I./ -std=gnu99
CXXFLAGS += -Wall -pedantic -I./
PREFIX   =  /usr/local

ifdef DEBUG
CFLAGS   += -ggdb -O0
CXXFLAGS += -ggdb -O0
endif

.PHONY: all cutils check net install uninstall clean mrpropre mrpropre debug

all: utils check net

utils: ../../bin/libcutils.o

check: ../../bin/libcutils-check.o

net: ../../bin/libcutils-net.o

SOURCES=$(wildcard *.c)
HEADERS=$(wildcard *.h)
OBJECTS=$(SOURCES:%.c=%.o)

array.o:   array.[ch]
desktop.o: desktop.[ch] array.h

../../bin/libcutils.o: $(OBJECTS)
	mkdir -p ../../bin
	# note: -r = --relocatable, but former also works with Clang
	$(LD) -r $(OBJECTS) -o $@

../../bin/libcutils-check.o: check/launcher.o
	mkdir -p ../../bin
	# note: -r = --relocatable, but former also works with Clang
	$(LD) -r check/launcher.o -o $@

../../bin/libcutils-net.o: net/net.o
	mkdir -p ../../bin
	# note: -r = --relocatable, but former also works with Clang
	$(LD) -r net/net.o -o $@

debug: 
	$(MAKE) -f makefile.d DEBUG=1

clean:
	rm -f *.o check/*.o net/*.o

mrproper: mrpropre

mrpropre: clean
	rm -f ../../bin/libcutils.o
	rm -f ../../bin/libcutils-check.o 
	rm -f ../../bin/lubcutils-net.o
	rmdir ../../bin 2>/dev/null || true

install: 
	@echo "installing cutils to $(PREFIX)..."
	mkdir -p "$(PREFIX)/lib/cutils/"
	cp ../../bin/libcutils.o       "$(PREFIX)/lib/cutils/"
	cp ../../bin/libcutils-check.o "$(PREFIX)/lib/cutils/"
	cp ../../bin/libcutils-net.o   "$(PREFIX)/lib/cutils/"
	mkdir -p "$(PREFIX)/include/cutils/check/"
	mkdir -p "$(PREFIX)/include/cutils/net/"
	cp *.h       "$(PREFIX)/include/cutils/"
	cp check/*.h "$(PREFIX)/include/cutils/check/"
	cp net/*.h   "$(PREFIX)/include/cutils/net/"

uninstall:
	@echo "uninstalling utils from $(PREFIX)..."
	rm -f "$(PREFIX)/lib/cutils/libcutils.o"
	rm -f "$(PREFIX)/lib/cutils/libcutils-check.o"
	rm -f "$(PREFIX)/lib/cutils/libcutils-net.o"
	rmdir "$(PREFIX)/lib/cutils/"          2>/dev/null || true
	rm -f "$(PREFIX)/include/cutils/net/"*.h
	rm -f "$(PREFIX)/include/cutils/check/"*.h
	rm -f "$(PREFIX)/include/cutils/"*.h
	rmdir "$(PREFIX)/include/cutils/net"   2>/dev/null || true
	rmdir "$(PREFIX)/include/cutils/check" 2>/dev/null || true
	rmdir "$(PREFIX)/include/cutils"       2>/dev/null || true

