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
 * @file test-array.c
 * @author Niki
 * @date 2022 - 2024
 *
 * @brief Unit tests for <tt>array</tt>
 *
 * This file implements a series of test cases for <tt>array</tt> from CUtils.
 */

#include "cutils/check/launcher.h"
#include "cutils/array.h"

#include <check.h>
#include <stddef.h>
#include <string.h>

static array_t *a;

static void setup() {
	a = new_array(sizeof(char), 80);
}

static void teardown() {
	free_array(a);
	a = NULL;
}

static void reset() {
	teardown();
	setup();
}

START(init)
		if (!a)
			failure("new_array returned NULL");

		if (array_count(a))
			failure("empty array has a size of %zu", array_count(a));

		END

START(clear)
		char car = 'T';

		array_push(a, &car);
		array_push(a, &car);
		array_clear(a);
		if (array_count(a))
			failure("empty array has a size of %zu", array_count(a));

		END

START(convert)
		char car = 'T';
		char eos = '\0';
		char *str;

		array_push(a, &car);
		array_push(a, &car);
		array_push(a, &eos);

		str = (char*) array_convert(a);
		assert_str("array of chars to string conversion", "TT", str);

		free(str);
		a = NULL;

		END

START(data)
		char car = 'T';
		char eos = '\0';
		char *str;

		array_push(a, &car);
		array_push(a, &car);
		array_push(a, &eos);

		str = (char*) array_data(a);
		assert_str("array of chars to string conversion", "TT", str);

		END

START(count)
		char car = 'T';
		char eos = '\0';

		assert_int("empty array", 0, array_count(a));
		reset();

		array_push(a, &car);
		assert_int("1-char array", 1, array_count(a));
		reset();

		array_push(a, &car);
		array_push(a, &car);
		array_push(a, &eos);
		assert_int("array with a NUL at the end", 3, array_count(a));
		reset();

		END

START(pointers)
		char *ptr;
		char car;

		ptr = array_new(a);
		*ptr = 'T';
		assert_int("add a new element via ptr", 1, array_count(a));

		ptr = array_first(a);
		car = *ptr;
		if (car != 'T')
			failure("first_ptr: 'T' was expected, but we got: '%c'", car);

		reset();

		char *testy = "Testy";
		ptr = array_newn(a, strlen(testy) + 1);
		for (size_t i = 0; i <= strlen(testy); i++) {
			*ptr = testy[i];
			ptr++;
		}

		ptr = array_first(a);
		for (size_t i = 0; i < strlen(testy); i++) {
			assert_str("next_ptr", testy + i, (char* )ptr);
			ptr = array_next(a, ptr);
		}

		array_loop_i(a, ptr2, char, i) {
			if (i < strlen(testy))
				assert_str("array_loop", testy + i, ptr2);
			else if (i == strlen(testy))
				assert_str("array_loop (last)", "", ptr2);
			else
				failure("array_loop went out of bounds");
		}

		END

START(get)
		char *str = "Testy";
		size_t sz = strlen(str);

		array_pushn(a, str, sz + 1);

		for (size_t i = 0; i < sz + 1; i++) {
			char expected = str[i];
			char *ret = array_get(a, i);
			assert_int("get each element", expected, *ret);
		}

		END

START(pop)
		char *rep;

		if (array_pop(a))
			failure("popping an item from an empty array");

		rep = array_new(a);
		*rep = 'T';

		rep = array_pop(a);
		if (!rep)
			failure("cannot pop item from 1-sized array");

		assert_int("bad item popped", (int )'T', (int )*rep);

		if (a->count)
			failure("popped 1-sized array still has %zu items", a->count);

		rep = array_new(a);
		*rep = 'T';
		rep = array_new(a);
		*rep = 'T';

		rep = array_pop(a);
		assert_int("bad item 1 popped", (int )'T', (int )*rep);
		assert_int("popping should remove 1 from count", 1, a->count);

		rep = array_pop(a);
		assert_int("bad item 2 popped", (int )'T', (int )*rep);
		assert_int("popping should remove 1 from count", 0, a->count);

		END

START(cut_at)
		char *rep;

		if (array_cut_at(a, 4))
			failure("cutting an empty array returned something");

		rep = array_new(a);
		*rep = 'T';
		rep = array_new(a);
		*rep = 'T';

		if (array_cut_at(a, 4))
			failure("cutting an array above its count returned something");

		if (!array_cut_at(a, 1))
			failure("failed to cut an array");
		assert_int("cutting at 1 should get a 1-sized array", 1,
				a->count);

		if (!array_cut_at(a, 0))
			failure("failed to cut an array");
		assert_int("cutting at 0 should get a 1-sized array", 0,
				a->count);

		END

START(compact)
		char car = 'T';
		char eos = '\0';

		array_compact(a);

		array_push(a, &car);
		array_push(a, &car);
		array_push(a, &eos);

		assert_str("compacted array has wrong data", "TT",
				(char* )array_data(a));

		END

		// TODO
START(NO_TEST_YET_qsort)
		END
START(NO_TEST_YET_push)
		END
START(NO_TEST_YET_set)
		END
START(NO_TEST_YET_copy)
		END

SRunner *test_array(SRunner *runner, int more) {
	Suite *suite = suite_create("array");

	TCase *core = tcase_create("core");
	tcase_add_checked_fixture(core, setup, teardown);
	tcase_add_test(core, init);
	tcase_add_test(core, clear);
	tcase_add_test(core, convert);
	tcase_add_test(core, data);
	tcase_add_test(core, count);
	tcase_add_test(core, pointers); // new, newn, first, next
	tcase_add_test(core, get);
	tcase_add_test(core, pop);
	tcase_add_test(core, cut_at);
	tcase_add_test(core, compact);

	tcase_add_test(core, NO_TEST_YET_qsort);
	tcase_add_test(core, NO_TEST_YET_push);
	tcase_add_test(core, NO_TEST_YET_set);
	tcase_add_test(core, NO_TEST_YET_copy);

	suite_add_tcase(suite, core);

	if (!runner)
		runner = srunner_create(suite);
	else
		srunner_add_suite(runner, suite);
	
	if (more) {
		Suite *suite = suite_create("array -- more (longer)");

		TCase *tmore = tcase_create("more");
		tcase_add_checked_fixture(tmore, setup, teardown);
		// TODO

		suite_add_tcase(suite, tmore);
		srunner_add_suite(runner, suite);
	}

	return runner;
}

