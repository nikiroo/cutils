#
# Makefile for makefile.opts
#
# Variables:
# > MUSL     : can be used to use musl libc instead of glibc
#              can be either the path to the spec gcc file or 'auto'
# > STATIC   : enable static mode (except glibc -- but see MUSL option)
# > NOSTATIC : reason why STATIC will not work, if any
#

################################################################################

OPTS = makefile.opts

.SUFFIXES:

# Default target
.PHONY: all

all:
	@if [ -e $(OPTS) ]; then \
		mv $(OPTS) $(OPTS).bkp; \
	fi
	
	@$(RM) $(OPTS)
	
	@if [ "$(STATIC)" = 1 -a "$(NOSTATIC)" != "" ]; then \
		echo >&2; \
		echo This project cannot be STATIC: "$(NOSTATIC)" >&2; \
		echo >&2; \
		false ;\
	fi
	
	@spmusl=; \
	if [ "$(MUSL)" = auto ]; then \
		for try in \
				"/usr/local/musl/lib/musl-gcc.specs" \
				"/usr/musl/lib/musl-gcc.specs" \
		; do \
			if [ -e "$$try" ]; then \
				spmusl="$$try"; \
			fi; \
		done;\
		if [ "$$spmusl" = "" ]; then \
			echo musl libc not found >&2; \
			exit 1; \
		fi;\
		/bin/echo -n " -specs $$spmusl " >> $(OPTS); \
	elif [ "$(MUSL)" != "" ]; then \
		/bin/echo -n " -specs $(MUSL)  " >> $(OPTS); \
	fi
	
	@static=; \
	if [ "$(STATIC)" = 1 ]; then \
		/bin/echo -n " -static " >> $(OPTS); \
	fi
	
	@touch $(OPTS)
	
	@if [ -e "$(OPTS).bkp" ]; then \
		if diff "$(OPTS)" "$(OPTS).bkp" >/dev/null; then \
			echo "$(OPTS)": no changes; \
			mv "$(OPTS).bkp" "$(OPTS)"; \
		else \
			echo "$(OPTS)": updated; \
			$(RM) "$(OPTS).bkp"; \
		fi; \
	else \
		echo "$(OPTS)": new; \
	fi

