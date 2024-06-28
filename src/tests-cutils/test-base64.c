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
 * @file test-base64.c
 * @author Niki
 * @date 2022 - 2024
 *
 * @brief Unit tests for <tt>base64</tt>
 *
 * This file implements a series of test cases for <tt>base64</tt> from CUtils.
 */

#include "cutils/base64.h"
#include "cutils/check/launcher.h"

#include <check.h>

static void setup() {
}

static void teardown() {
}

static char decoded[] = "This is Le Test, we will UTF-8 the String, too!";
static char encoded[] =
		"VGhpcyBpcyBMZSBUZXN0LCB3ZSB3aWxsIFVURi04IHRoZSBTdHJpbmcsIHRvbyE=";

static char decoded_utf8[] = "Le café d'Abigaëlle";
static char encoded_utf8[] = "TGUgY2Fmw6kgZCdBYmlnYcOrbGxl";

START(decode)
		char *tmp = base64_decode(encoded);
		assert_str("decoding", decoded, tmp);
		free(tmp);
		END

START(encode)
		char *tmp = base64_encode(decoded);
		assert_str("encoding", encoded, tmp);
		free(tmp);
		END

START(utf8)
		char *tmp;

		tmp = base64_decode(encoded_utf8);
		assert_str("UTF-8 decoding", decoded_utf8, tmp);
		free(tmp);

		tmp = base64_encode(decoded_utf8);
		assert_str("UTF-8 encoding", encoded_utf8, tmp);
		free(tmp);

		END

START(both_ways)
		char *enc = base64_encode(decoded);
		char *dec = base64_decode(enc);
		assert_str("both ways DEC", decoded, dec);
		assert_str("both ways ENC", encoded, enc);
		free(dec);
		free(enc);
		END

START(big)
		size_t sz = 10 * 1024 * 1024;
		char *dec = malloc((sz + 1) * sizeof(char));
		for (int i = 0; i < sz; i++) {
			dec[i] = '0' + (i % 10);
		}
		dec[sz] = '\0';

		char *enc = base64_encode(dec);
		char *dec2 = base64_decode(enc);

		assert_str("long encode/decode cycle", dec, dec2);
		free(dec2);
		free(enc);
		free(dec);

		END

START(lots)
		size_t count = 1 * 1000 * 1000;
		for (size_t i = 0; i < count; i++) {
			char *enc = base64_encode(decoded);
			char *dec = base64_decode(enc);

			if (strcmp(decoded, dec)) {
				failure("Failed short encode/decode cycle at index %zu", i);
			}

			free(enc);
			free(dec);
		}

		END

SRunner *test_base64(SRunner *runner, int more) {
	Suite *suite = suite_create("Base64");

	TCase *core = tcase_create("core");
	tcase_add_checked_fixture(core, setup, teardown);
	tcase_add_test(core, decode);
	tcase_add_test(core, encode);
	tcase_add_test(core, utf8);

	suite_add_tcase(suite, core);
	
	if (!runner)
		runner = srunner_create(suite);
	else
		srunner_add_suite(runner, suite);
	
	if (more) {
		Suite *suite = suite_create("Base64 -- more (longer)");

		TCase *tmore = tcase_create("more");
		tcase_add_checked_fixture(tmore, setup, teardown);
		tcase_add_test(tmore, both_ways);
		tcase_add_test(tmore, big);
		tcase_add_test(tmore, lots);

		suite_add_tcase(suite, tmore);
		srunner_add_suite(runner, suite);
	}

	return runner;
}

