#
# Makefile for C libraries
# > NAME   : the name of the main program (if programs, make a single .d file 
#            per program, link them up in Makfile and use a $ssrcdir)
# > NOSTATIC : reason why STATIC will not work, if any
# > srcdir : the source directory
# > ssrcdir: the sub-sources directory (defaults to $srcdir)
# > dstdir : the destination directory (defaults to $srcdir/bin)
#
# Environment variables:
# > PREFIX: where to (un)install (defaults to /usr/local)
# > DEBUG: define it to build with all debug symbols
# > MUSL     : can be used to use musl libc instead of glibc
#              can be either the path to the spec gcc file or 'auto'
# > STATIC   : enable static mode (except glibc -- but see MUSL option)
#

NAME    = cutils
srcdir  = $(NAME)
ssrcdir = $(srcdir)

# Note: c99+ required for for-loop initial declaration (not default in CentOS 6)
# Note: gnu99 can be required for some projects (i.e.: libcutils-net)
CFLAGS   += -Wall -pedantic -I./ -std=gnu99
CXXFLAGS += -Wall -pedantic -I./
PREFIX    =  /usr/local

# If you require dynamic libraries and STATIC will not work: reason why
# NOSTATIC = "libcheck is linked to m, rt and glicb"

# Required *locally compiled* libraries if any:
# LIBS     = cutils

################################################################################

.SUFFIXES:
.SUFFIXES: .c .h .o .d

ifeq ($(dstdir),)
dstdir = $(srcdir)/bin
endif

ifdef DEBUG
CFLAGS   += -ggdb -O0
CXXFLAGS += -ggdb -O0
endif

# Default target
.PHONY: all
all:

.PHONY: build rebuild install uninstall clean mrpropre mrpropre \
	$(NAME) test run run-test run-test-more opts

SOURCES=$(wildcard $(ssrcdir)/*.c)
OBJECTS=$(SOURCES:%.c=%.o)
DEPENDS =$(SOURCES:%.c=%.d)

# Autogenerate dependencies from code
-include $(DEPENDS)
%.o: %.c $(ssrcdir)/makefile.opts
	$(CC) $(CFLAGS) -MMD -MP -c $< `cat $(ssrcdir)/makefile.opts` -o $@

# Static and MUSL support
opts:
	@# updates the .opts file (but only if STATIC or MUSL changed)
	$(MAKE) --no-print-directory -C $(ssrcdir) -f makefile.opts.d \
		MUSL=$(MUSL) STATIC=$(STATIC) NOSTATIC=$(NOSTATIC)

# Main targets

all: build

build: $(NAME)

rebuild: clean build

$(NAME): opts $(dstdir)/lib$(NAME).a

# Library, so no test and no run
test run run-test run-test-more:
	@echo $(NAME) is a library, look at the tests instead

$(dstdir)/lib$(NAME).a: $(OBJECTS) $(ssrcdir)/makefile.opts
	mkdir -p $(dstdir)
	@## OLD: #note: -r = --relocatable, but former also works with Clang
	@## OLD: $(LD) -r $(OBJECTS) -o $@ $(LDFLAGS)
	$(AR) rcs $@ $(OBJECTS)

clean:
	$(foreach lib,$(LIBS),$(MAKE) --no-print-directory \
			-C $(lib)/ $@ dstdir=$(dstdir))
	$(RM) $(OBJECTS)
	$(RM) $(DEPENDS)
	$(RM) $(ssrcdir)/makefile.opts

mrproper: mrpropre
mrpropre: clean
	$(foreach lib,$(LIBS),$(MAKE) --no-print-directory \
			-C $(lib)/ $@ dstdir=$(dstdir))
	$(RM) $(dstdir)/lib$(NAME).a
	rmdir $(dstdir) 2>/dev/null || true

install: build
	mkdir -p "$(PREFIX)/lib"
	cp "$(dstdir)/lib$(NAME).a" "$(PREFIX)/lib/"
	cp "$(ssrcdir)"/*.h       "$(PREFIX)/include/$(srcdir)/"

uninstall:
	$(RM) "$(PREFIX)/lib/lib$(NAME).a"
	rmdir "$(PREFIX)/lib"               2>/dev/null
	$(RM) "$(PREFIX)/include/$(srcdir)/"*.h
	rmdir "$(PREFIX)/include/$(srcdir)" 2>/dev/null
	rmdir "$(PREFIX)/include"           2>/dev/null

