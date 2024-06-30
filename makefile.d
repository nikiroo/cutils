# Note: 99+ required for for-loop initial declaration (CentOS 6)
# Note: gnu99 (instead of c99) required for libcutils-net

NAME   = cutils
NAMES  = $(NAME) check net
srcdir = $(NAME)
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

SOURCES_cutils=$(wildcard $(srcdir)/*.c)
OBJECTS_cutils=$(SOURCES_cutils:%.c=%.o)
SOURCES_check =$(wildcard $(srcdir)/check/*.c)
OBJECTS_check =$(SOURCES_check:%.c=%.o)
SOURCES_net   =$(wildcard $(srcdir)/net/*.c)
OBJECTS_net   =$(SOURCES_net:%.c=%.o)

# Main targets

all: build

build: $(NAMES)

cutils: deps $(dstdir)/libcutils.o
check:  deps $(dstdir)/libcutils-check.o
net:    deps $(dstdir)/libcutils-net.o

run:
	@echo CUtils is a library, look at the tests instead

################
# Dependencies #
################
# ## Libs (if needed)
deps:
#	$(MAKE) --no-print-directory -C cutils/ cutils
# DEPS=$(dstdir)/libcutils.o

## Headers
DEPENDS =$(SOURCES_cutils:%.c=%.d)
DEPENDS+=$(SOURCES_check:%.c=%.d)
DEPENDS+=$(SOURCES_net:%.c=%.d)
-include $(DEPENDS)
%.o: %.c
	$(CC) $(CFLAGS) -MMD -MP -c $< -o $@
################

$(dstdir)/libcutils.o: $(DEPS) $(OBJECTS_cutils)
	mkdir -p $(dstdir)
	# note: -r = --relocatable, but former also works with Clang
	$(LD) -r $(DEPS) $(OBJECTS_cutils) -o $@

$(dstdir)/libcutils-check.o: $(DEPS) $(OBJECTS_check)
	mkdir -p $(dstdir)
	# note: -r = --relocatable, but former also works with Clang
	$(LD) -r $(DEPS) $(OBJECTS_check) -o $@

$(dstdir)/libcutils-net.o: $(DEPS) $(OBJECTS_net)
	mkdir -p $(dstdir)
	# note: -r = --relocatable, but former also works with Clang
	$(LD) -r $(DEPS) $(OBJECTS_net) -o $@

debug: 
	$(MAKE) -f $(srcdir)/makefile.d DEBUG=1

clean:
	rm -f $(OBJECTS_cutils)
	rm -f $(OBJECTS_check)
	rm -f $(OBJECTS_net)
	rm -f $(DEPENDS)

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

