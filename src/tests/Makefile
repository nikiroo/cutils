# Simply pass everything to makefile.d, but calling from "../"

.PHONY: MK all install uninstall clean mrpropre mrpropre \
	run test run-test run-test-more

$(MAKECMDGOALS): MK
MK:
	@$(MAKE) --no-print-directory -C ../ -f $(CURDIR)/makefile.d \
	$(MAKECMDGOALS)

