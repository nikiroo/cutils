# CUtils

Small C utilities.

## Synopsis

You may use it in various ways.

Simply clone the repository (branch: master) in your `src/` directory:
- call **make** with `make -f src/cutils`
- it will use bin/ as output directory by default (variable dstdir)
- use `#include "cutils/cutils.h"` (for instance -- notice the double quotes)
- use the required `.a` file(s): `gcc bin/xxx.o bin/libcutils.a -o bin/my-prog`
- ...or via `-l`: `gcc bin/xxx.o -o bin/my-prog -lcutils -Lbin/`

Install it on your machine:
- compile and install it (see **Compilation** below)
- use `#include <cutils/cutils.h>` (for instance -- notice the square brackets)
- use one or more of of `-lcutils`, `-lcutils-net` or `-lcutils-check`

Use a local version merged with your own sources:
- locally generate the `.a` files (see **Compilation** below)
- use `#include "cutils/cutils.h"` (for instance -- notice the double quotes)
- use the required `.o` file(s): `gcc bin/xxx.o bin/libcutils.o -o bin/my-prog`

## Description

Some small utilities written in C, as a helper library.

They are separated in 3 binaries:
- **libcutils**: most of the utilities lie there
- **libcutils-net**: some network related reading/writing functions (requires GNU 99 C extensions)
- **libcutils-check**: some helper functions for the test library **check.h**


## Compilation

Just run `make`.  

You can also use those make targets:

- `make doc`: build the Doxygen documentation (`doxygen` required)
- `make man`: build the man page (`pandoc` required)
- `make install PREFIX=/usr/local`: install the program into PREFIX (default is `/usr/local`) and the manual if built
- `make uninstall PREFIX=/usr/local`: uninstall the program from the given PREFIX
- `make clear`: clear the temporary files
- `make mrpropre`: clear everything, including the main executable and the documentation
- `make test`: build the unit tests (`check` required)
- `make run-test`: start the unit tests
- `make run-test-more`: start the extra unit tests (can be long)

## Author

CUtils was written by Niki Roo <niki@nikiroo.be>

