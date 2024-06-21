#include "cutils/check/launcher.h"
#include "cutils/cstring.h"

cstring_t *s;

void t_cstring_setup() {
}

void t_cstring_teardown() {
}

START(add)
	if (0)
		FAIL("Oopsie: %s", "why?!");
END

START(add_mem)
	if (0)
		FAIL("Oopsie: %s", "why?!");
END

Suite *test_cstring(int more) {
	Suite *suite = suite_create("cstring");
	
	TCase *init = tcase_create("core");
	tcase_add_checked_fixture(init, t_cstring_setup, t_cstring_teardown);
	tcase_add_test(init, add);
	
	suite_add_tcase(suite, init);
	
	if (more) {
		TCase *extra = tcase_create("extra");
		tcase_add_checked_fixture(extra, 
				t_cstring_setup, t_cstring_teardown);
		tcase_add_test(init, add_mem);
		
		suite_add_tcase(suite, extra);
	}
	
	return suite;
}

