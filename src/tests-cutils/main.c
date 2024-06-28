#include <check.h>
#include "cutils/check/launcher.h"

// The tests we intend to run:

SRunner *test_cstring(SRunner *runner, int more);
SRunner *test_array  (SRunner *runner, int more);
SRunner *test_base64 (SRunner *runner, int more);
SRunner *test_desktop(SRunner *runner, int more);

SRunner *get_tests(int more) {
	SRunner *runner = NULL;
	
	runner = test_cstring(runner, more);
	runner = test_array  (runner, more);
	runner = test_base64 (runner, more);
	runner = test_desktop(runner, more);
	
	return runner;
}

int main(int argc, char **argv) {
	return launch_tests(argc, argv);
}

