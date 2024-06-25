# Note: 99+ required for for-loop initial declaration (CentOS 6)

srcdir = tests
dstdir = ../bin

CFLAGS   += -Wall -pedantic -I./ -std=c99
CXXFLAGS += -Wall -pedantic -I./
LDFLAGS  += -lcheck

ifdef DEBUG
CFLAGS   += -ggdb -O0
CXXFLAGS += -ggdb -O0
endif

.PHONY: all install uninstall clean mrpropre mrpropre \
	test run run-test run-test-more

SOURCES=$(wildcard $(srcdir)/*.c)
HEADERS=$(wildcard $(srcdir)/*.h)
OBJECTS=$(SOURCES:%.c=%.o)

################
# Dependencies #
################
OBJECTS+=$(dstdir)/libcutils.o
OBJECTS+=$(dstdir)/libcutils-check.o
$(dstdir)/libcutils.o:
	$(MAKE) --no-print-directory -C cutils/ utils
$(dstdir)/libcutils-check.o:
	$(MAKE) --no-print-directory -C cutils/ check
################

all: test

test: $(dstdir)/tests

run: run-test
run-test: test
	@echo
	@$(dstdir)/tests

run-test-more: test
	@echo
	@$(dstdir)/tests --more


$(dstdir)/tests: $(OBJECTS)
	mkdir -p $(dstdir)
	$(CC) $(CFLAGS) $(LDFLAGS) $(OBJECTS) -o $@

clean:
	rm -f $(srcdir)/*.o

mrproper: mrpropre
mrpropre: clean
	rm -f $(dstdir)/tests
	rmdir $(dstdir) 2>/dev/null || true

