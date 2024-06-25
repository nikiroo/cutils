#ifndef _LAUNCHER_H
#define _LAUNCHER_H

#include <check.h>

#define START(name) \
START_TEST(name) {\
	test_init(#name);\

#define END \
	test_success();\
}\
END_TEST\

#define failure(...) do { \
	test_failure(); \
	ck_abort_msg(__VA_ARGS__); \
} while(0)

void assert_str(const char title[], const char expected[],
		const char received[]);

void assert_int(const char title[], long long expected, long long received);

void assert_sz(const char title[], size_t expected, size_t received);

extern int launcher_color;

SRunner *get_tests(int more);

void test_init(const char name[]);

int test_start(int more);

void test_success();

void test_failure();

#endif

