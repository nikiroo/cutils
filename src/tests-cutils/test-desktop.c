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
 * @file test-desktop.c
 * @author Niki
 * @date 2022 - 2024
 *
 * @brief Unit tests for <tt>desktop</tt>
 *
 * This file implements a series of test cases for <tt>desktop</tt> from CUtils.
 */

#include "cutils/check/launcher.h"
#include "cutils/desktop.h"

#include <check.h>

#define TEST_FILE_DESKTOP "../data/tests-cutils/test.desktop"

desktop_t *d;

static void setup() {
	d = new_desktop(TEST_FILE_DESKTOP, 24);
}

static void teardown() {
	free_desktop(d);
}

START(init)
		if (!d)
			failure("new_desktop returned NULL");

		assert_str("Name", "IRC", d->name);
		assert_str("Icon", "irssi", d->icon);
		assert_str("Exec", "irssi", d->icon);

		END

		// TODO
START(NO_TEST_YET_submenu)
		END
START(NO_TEST_YET_icons)
		END
START(NO_TEST_YET_find_icon)
		END
START(NO_TEST_YET_find_id)
		END

SRunner *test_desktop(SRunner *runner, int more) {
	Suite *suite = suite_create("desktop");

	TCase *core = tcase_create("core");
	tcase_add_checked_fixture(core, setup, teardown);
	tcase_add_test(core, init);
	tcase_add_test(core, NO_TEST_YET_submenu);
	tcase_add_test(core, NO_TEST_YET_icons);
	tcase_add_test(core, NO_TEST_YET_find_icon);
	tcase_add_test(core, NO_TEST_YET_find_id);

	suite_add_tcase(suite, core);
	
	if (!runner)
		runner = srunner_create(suite);
	else
		srunner_add_suite(runner, suite);
	
	if (more) {
		Suite *suite = suite_create("desktop -- more (longer)");

		TCase *tmore = tcase_create("more");
		tcase_add_checked_fixture(tmore, setup, teardown);
		// TODO

		suite_add_tcase(suite, tmore);
		srunner_add_suite(runner, suite);
	}
	
	return runner;
}

