#ifndef TESTS_H
#define TESTS_H

#include <check.h>

/**
 * Return the test runner (the list of tests to run).
 *
 * @param mem manage the memory checks and can be:
 * 	- 0 for no memory checks
 * 	- 1 for memory checks
 * 	- 2 for memory checks only
 */
SRunner *get_tests(int more);

Suite *test_cstring(int more);
// ...

#endif

