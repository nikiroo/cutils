# Simply pass everything to makefile.d, but calling from "../"

.PHONY: all build install uninstall clean mrpropre mrpropre \
	run test run-test run-test-more default \
	tests-cutils

default $(MAKECMDGOALS):
	@$(MAKE) --no-print-directory -C ../ -f $(CURDIR)/makefile.d \
	$(MAKECMDGOALS)

