# Simply pass everything to makefile.d, but calling from "../"

.PHONY: default $(MAKECMDGOALS)

default $(MAKECMDGOALS):
	@for mk in makefile.d makefile.check.d makefile.net.d; do \
		$(MAKE) --no-print-directory -C ../ -f "$(CURDIR)/$$mk" \
			$(MAKECMDGOALS);
	done;

