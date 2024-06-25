NAME   = cutils
dstdir = bin

.PHONY: all run clean mrpropre mrpropre love debug doc man \
	test run-test run-test-more \
	mess-run mess-clean mess-propre mess-doc mess-man \
	mess-test mess-run-test mess-run-test-more \
	$(NAME) utils net check \
	MK MKTEST MKMAN

all: $(NAME)

# Sub makes:
M_OPTS=$(MAKECMDGOALS) --no-print-directory PREFIX=$(PREFIX)
MK:
	@$(MAKE) -C src/$(NAME) $(M_OPTS) DEBUG=$(DEBUG)
MKTEST:
	@$(MAKE) -C src/tests   $(M_OPTS) DEBUG=$(DEBUG)
MKMAN:
	@$(MAKE) -f man.d       $(M_OPTS) NAME=$(NAME)

# Main buildables
$(NAME): utils net check
utils: MK
net: MK
check: MK

# Run
run: mess-run
	@echo Nothing to run, this is a library

# Test + run test
test: mess-test MKTEST
run-test: mess-run-test MKTEST
run-test-more: mess-run-test-more MKTEST

# Doc/man/misc
doc: mess-doc
	doxygen
man: mess-man MKMAN
love:
	@echo " ...not war."
debug:
	$(MAKE) $(M_OPTS) DEBUG=1

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
mess-run-test-more:
	@echo ">>>>>>>>>> Running more tests on $(NAME)..."
mess-install:
	@echo ">>>>>>>>>> Installing $(NAME) into $(PREFIX)..."
mess-uninstall:
	@echo ">>>>>>>>>> Uninstalling $(NAME) from $(PREFIX)..."

