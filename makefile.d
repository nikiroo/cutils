# Note: 99+ required for for-loop initial declaration (CentOS 6)
# Note: gnu99 (instead of c99) required for libcutils-net

NAME   = cutils
NAMES  = $(NAME) check net
srcdir = cutils
dstdir = ../bin

CFLAGS   += -Wall -pedantic -I./ -std=gnu99
CXXFLAGS += -Wall -pedantic -I./
# LDFLAGS  += -lcheck
PREFIX   =  /usr/local

ifdef DEBUG
CFLAGS   += -ggdb -O0
CXXFLAGS += -ggdb -O0
endif

.PHONY: all build install uninstall clean mrpropre mrpropre \
	$(NAMES)

SOURCES=$(wildcard $(srcdir)/*.c)
HEADERS=$(wildcard $(srcdir)/*.h)
OBJECTS=$(SOURCES:%.c=%.o)

# Main targets

all: build

build: $(NAMES)

cutils: $(dstdir)/libcutils.o
check: $(dstdir)/libcutils-check.o
net: $(dstdir)/libcutils-net.o

################
# Dependencies #
################
# OBJECTS+=$(dstdir)/libcutils.o
# $(dstdir)/libcutils.o:
# 	$(MAKE) --no-print-directory -C cutils/ cutils
$(srcdir)/array.o:   $(srcdir)/array.[ch]
$(srcdir)/desktop.o: $(srcdir)/desktop.[ch] $(srcdir)/array.h
################

$(dstdir)/libcutils.o: $(OBJECTS)
	mkdir -p $(dstdir)
	# note: -r = --relocatable, but former also works with Clang
	$(LD) -r $(OBJECTS) -o $@

$(dstdir)/libcutils-check.o: $(srcdir)/check/launcher.o
	mkdir -p $(dstdir)
	# note: -r = --relocatable, but former also works with Clang
	$(LD) -r $(srcdir)/check/launcher.o -o $@

$(dstdir)/libcutils-net.o: $(srcdir)/net/net.o
	mkdir -p $(dstdir)
	# note: -r = --relocatable, but former also works with Clang
	$(LD) -r $(srcdir)/net/net.o -o $@

debug: 
	$(MAKE) -f $(srcdir)/makefile.d DEBUG=1

clean:
	rm -f $(srcdir)/*.o $(srcdir)/*/*.o

mrproper: mrpropre

mrpropre: clean
	rm -f $(dstdir)/libcutils.o
	rm -f $(dstdir)/libcutils-check.o 
	rm -f $(dstdir)/libcutils-net.o
	rmdir $(dstdir) 2>/dev/null || true

install: 
	mkdir -p "$(PREFIX)/lib"
	cp $(dstdir)/libcutils.o       "$(PREFIX)/lib/libcutils.a"
	cp $(dstdir)/libcutils-check.o "$(PREFIX)/lib/libcutils-check.a"
	cp $(dstdir)/libcutils-net.o   "$(PREFIX)/lib/libcutils-net.a"
	mkdir -p "$(PREFIX)/include/$(srcdir)/check/"
	mkdir -p "$(PREFIX)/include/$(srcdir)/net/"
	cp $(srcdir)/*.h       "$(PREFIX)/include/$(srcdir)/"
	cp $(srcdir)/check/*.h "$(PREFIX)/include/$(srcdir)/check/"
	cp $(srcdir)/net/*.h   "$(PREFIX)/include/$(srcdir)/net/"

uninstall:
	rm "$(PREFIX)/lib/libcutils.a"
	rm "$(PREFIX)/lib/libcutils-check.a"
	rm "$(PREFIX)/lib/libcutils-net.a"
	rmdir "$(PREFIX)/lib/"                    2>/dev/null
	rm "$(PREFIX)/include/$(srcdir)/net/"*.h
	rm "$(PREFIX)/include/$(srcdir)/check/"*.h
	rm "$(PREFIX)/include/$(srcdir)/"*.h
	rmdir "$(PREFIX)/include/$(srcdir)/net"   2>/dev/null
	rmdir "$(PREFIX)/include/$(srcdir)/check" 2>/dev/null
	rmdir "$(PREFIX)/include/$(srcdir)"       2>/dev/null
	rmdir "$(PREFIX)/include/"                2>/dev/null

