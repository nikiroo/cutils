# Note: 99+ required for for-loop initial declaration (CentOS 6)

NAME   = tests-cutils
srcdir = $(NAME)
dstdir = ../bin

CFLAGS   += -Wall -pedantic -I./ -std=c99
CXXFLAGS += -Wall -pedantic -I./
LDFLAGS  += -lcheck
PREFIX   =  /usr/local

ifdef DEBUG
CFLAGS   += -ggdb -O0
CXXFLAGS += -ggdb -O0
endif

.PHONY: all build install uninstall clean mrpropre mrpropre \
	$(NAME) test run run-test run-test-more

SOURCES=$(wildcard $(srcdir)/*.c)
HEADERS=$(wildcard $(srcdir)/*.h)
OBJECTS=$(SOURCES:%.c=%.o)

# Main target

all: build

build: $(NAME)

$(NAME): $(dstdir)/$(NAME)

################
# Dependencies #
################
OBJECTS+=$(dstdir)/libcutils.o
OBJECTS+=$(dstdir)/libcutils-check.o
$(dstdir)/libcutils.o:
	$(MAKE) --no-print-directory -C cutils/ cutils
$(dstdir)/libcutils-check.o:
	$(MAKE) --no-print-directory -C cutils/ check
################

$(dstdir)/$(NAME): $(OBJECTS)
	mkdir -p $(dstdir)
	$(CC) $(CFLAGS) $(LDFLAGS) $(OBJECTS) -o $@

# Test program, so running = running tests
run: run-test
test: build

run-test: test
	@echo
	@$(dstdir)/$(NAME)
run-test-more: test
	@echo
	@$(dstdir)/($NAME) --more

clean:
	rm -f $(srcdir)/*.o $(srcdir)/*/*.o

mrproper: mrpropre
mrpropre: clean
	rm -f $(dstdir)/$(NAME)
	rmdir $(dstdir) 2>/dev/null || true

