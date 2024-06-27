#include <check.h>
#include "tests.h"

SRunner *get_tests(int more) {
	SRunner *runner;
	
	runner = srunner_create(test_cstring(more));
	//srunner_add_suite(runner, test_clist(more));
	//srunner_add_suite(runner, test_string(mem));
	//srunner_add_suite(runner, test_buffer(mem));
	//srunner_add_suite(runner, other_suite());
	// ...
	
	return runner;
}

