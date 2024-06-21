NAME   = cutils
dstdir = bin

.PHONY: all build rebuild run clean mrpropre mrpropre love debug doc man \
	test tests run-test run-tests run-test-more run-tests-more \
	mess-build mess-run mess-clean mess-propre mess-doc mess-man \
	mess-test mess-run-test mess-run-test-more \
	$(NAME) utils net check \
	MK MKTEST MKMAN

all: build

# Sub makes:
MK:
	@$(MAKE) -C src/$(NAME) $(MAKECMDGOALS) DEBUG=$(DEBUG)
MKTEST:
	@$(MAKE) -C src/tests   $(MAKECMDGOALS) DEBUG=$(DEBUG)
MKMAN:
	@$(MAKE) -f man.d       $(MAKECMDGOALS) NAME=$(NAME) PREFIX=$(PREFIX)

# Main buildables
$(NAME): utils net check
utils: MK
net: MK
check: MK

# Run
run: mess-run
	@echo Nothing to run, this is a library

# Build/rebuild
build: mess-build $(NAME)
	@echo Build successful.
rebuild: clean build

# Test + run test
tests: test
test: mess-test MKTEST
run-tests: run-test
run-test: mess-run-test MKTEST
run-tests-more: run-test-more
run-test-more: mess-run-test-more MKTEST

# Doc/man/misc
doc: mess-doc
	doxygen
man: mess-man MKMAN
love:
	@echo " ...not war."
debug:
	$(MAKE) DEBUG=1

# Clean
clean: mess-clean MK MKTEST
mrproper: mrpropre
mrpropre: mess-propre MK MKTEST MKMAN
	rm -rf doc/html doc/latex doc/man
	rmdir doc 2>/dev/null || true

# Install/uninstall
install: mess-install MK MKMAN
uninstall: mess-uninstall MK MKMAN

# Messages
mess-build:
	@echo ">>>>>>>>>> Building $(NAME)..."
mess-run:
	@echo ">>>>>>>>>> Running $(NAME)..."
	@echo
mess-clean:
	@echo ">>>>>>>>>> Cleaning $(NAME)..."
mess-propre:
	@echo ">>>>>>>>>> Calling Mr Propre..."
mess-doc:
	@echo ">>>>>>>>>> Generating documentation for $(NAME)..."
mess-man:
	@echo ">>>>>>>>>> Generating the manual of $(NAME)..."
mess-test:
	@echo ">>>>>>>>>> Building tests for $(NAME)..."
mess-run-test:
	@echo ">>>>>>>>>> Running tests on $(NAME)..."
	@echo
mess-run-test-more:
	@echo ">>>>>>>>>> Running more tests on $(NAME)..."
	@echo
mess-install:
	@echo ">>>>>>>>>> Installing $(NAME) into $(PREFIX)..."
mess-uninstall:
	@echo ">>>>>>>>>> Uninstalling $(NAME) from $(PREFIX)..."

