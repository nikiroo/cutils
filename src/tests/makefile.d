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

all: test

test: $(dstdir)/tests

run: run-test
run-test: test
	$(dstdir)/tests

run-test-more: test
	$(dstdir)/tests --more

SOURCES=$(wildcard $(srcdir)/*.c)
HEADERS=$(wildcard $(srcdir)/*.h)
OBJECTS=$(SOURCES:%.c=%.o)
OBJECTS+=$($(dstdir)/libcutils.o)

$(dstdir)/tests: $(OBJECTS) $(dstdir)/libcutils-check.o
	mkdir -p $(dstdir)
	$(CC) $(CFLAGS) $(LDFLAGS) $(OBJECTS) $(dstdir)/libcutils-check.o -o $@

clean:
	rm -f $(srcdir)/*.o

mrproper: mrpropre
mrpropre: clean
	rm -f $(dstdir)/tests
	rmdir $(dstdir) 2>/dev/null || true

