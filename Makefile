# Simply pass everything to makefile.d, but calling from "../"

.PHONY: MK all install uninstall clean mrpropre mrpropre \
	utils check net

$(MAKECMDGOALS): MK
MK:
	@$(MAKE) --no-print-directory -C ../ -f $(CURDIR)/makefile.d \
	$(MAKECMDGOALS)

