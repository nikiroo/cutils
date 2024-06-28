/*
 * CUtils: some small C utilities
 *
 * Copyright (C) 2022 Niki Roo
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

/**
 * @file launcher.h
 * @author Niki
 * @date 2022 - 2024
 *
 * @brief Unit test helper (based upon <tt>check</tt>)
 *
 * This file offers a series of help functions for the <tt>check</tt> C unit
 * tests system.
 */

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

/**
 * Return the test runner (the list of tests to run).
 *
 * @param more activate more, longer checks (usually memory related)
 */
SRunner *get_tests(int more);

void test_init(const char name[]);

int test_start(int more);

void test_success();

void test_failure();

int launch_tests(int argc, char **argv);

#endif

