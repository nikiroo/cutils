# Note: 99+ required for for-loop initial declaration (CentOS 6)

NAME   = tests-cutils
NAMES  = $(NAME)
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
	$(NAME) deps test run run-test run-test-more

SOURCES=$(wildcard $(srcdir)/*.c)
HEADERS=$(wildcard $(srcdir)/*.h)
OBJECTS=$(SOURCES:%.c=%.o)

# Main target

all: build

build: $(NAMES)

$(NAME): deps $(dstdir)/$(NAME)

################
# Dependencies #
################
## Libs (if needed)
deps:
	$(MAKE) --no-print-directory -C cutils/ cutils
	$(MAKE) --no-print-directory -C cutils/ check
DEPS=$(dstdir)/libcutils.o $(dstdir)/libcutils-check.o

## Headers
DEPENDS=$(SOURCES:%.c=%.d)
-include $(DEPENDS)
%.o: %.c
	$(CC) $(CCFLAGS) -MMD -MP -c $< -o $@
################

$(dstdir)/$(NAME): $(DEPS) $(OBJECTS)
	mkdir -p $(dstdir)
	$(CC) $(CFLAGS) $(LDFLAGS) $(DEPS) $(OBJECTS) -o $@

# Test program, so running = running tests
run: run-test
test: build

run-test: test
	@echo
	@$(dstdir)/$(NAME)
run-test-more: test
	@echo
	@$(dstdir)/$(NAME) --more

clean:
	rm -f $(OBJECTS) $(DEPENDS)

mrproper: mrpropre
mrpropre: clean
	rm -f $(dstdir)/$(NAME)
	rmdir $(dstdir) 2>/dev/null || true

