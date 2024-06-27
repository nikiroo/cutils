NAME   = cutils
NAMES  = $(NAME)
TEST   = tests-cutils
TESTS  = $(TEST)

PREFIX =  /usr/local

dstdir = bin

.PHONY: all build run clean mrpropre mrpropre love debug doc man \
	test run-test run-test-more \
	mess-build mess-run mess-clean mess-propre mess-doc mess-man \
	mess-test mess-run-test mess-run-test-more \
	$(NAMES) $(TESTS)

all: build

build: mess-build $(NAMES)

test: mess-test $(TESTS)

# Main buildables
M_OPTS=$(MAKECMDGOALS) --no-print-directory PREFIX=$(PREFIX) DEBUG=$(DEBUG)
$(NAMES) $(TESTS):
	$(MAKE) -C src/$@ $(M_OPTS) 

# Manual
man: mess-man
	@$(MAKE) -f man.d $(M_OPTS) NAME=$(NAME)

# Run
run: mess-run
	@echo Nothing to run, this is a library

# Run main test
run-test: mess-run-test $(TEST)
run-test-more: mess-run-test-more $(TEST)

# Doc/man/misc
doc: mess-doc
	doxygen
love:
	@echo " ...not war."
debug:
	$(MAKE) $(M_OPTS) DEBUG=1

# Clean
clean: mess-clean $(NAMES) $(TESTS)
mrproper: mrpropre
mrpropre: mess-propre $(NAMES) $(TESTS) man
	rm -rf doc/html doc/latex doc/man
	rmdir doc 2>/dev/null || true

# Install/uninstall
install: mess-install $(NAME) man
uninstall: mess-uninstall $(NAME) man

# Messages
mess-build:
	@echo
	@echo ">>>>>>>>>> Building $(NAMES)..."
mess-run:
	@echo
	@echo ">>>>>>>>>> Running $(NAME)..."
mess-clean:
	@echo
	@echo ">>>>>>>>>> Cleaning $(NAME)..."
mess-propre:
	@echo
	@echo ">>>>>>>>>> Calling Mr Propre..."
mess-doc:
	@echo
	@echo ">>>>>>>>>> Generating documentation for $(NAME)..."
mess-man:
	@echo
	@echo ">>>>>>>>>> Generating the manual of $(NAME)..."
mess-test:
	@echo
	@echo ">>>>>>>>>> Building all tests: $(TESTS)..."
mess-run-test:
	@echo
	@echo ">>>>>>>>>> Running tests: $(TEST)..."
mess-run-test-more:
	@echo
	@echo ">>>>>>>>>> Running more tests: $(TEST)..."
mess-install:
	@echo
	@echo ">>>>>>>>>> Installing $(NAME) into $(PREFIX)..."
mess-uninstall:
	@echo
	@echo ">>>>>>>>>> Uninstalling $(NAME) from $(PREFIX)..."

