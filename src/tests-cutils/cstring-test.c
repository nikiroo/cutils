#include "cutils/check/launcher.h"
#include "cutils/cstring.h"
#include "cutils/timing.h"

cstring_t *s;

static const char str100[101] = 
	"12345678901234567890123456789012345678901234567890"
	"12345678901234567890123456789012345678901234567890"
;

void t_cstring_setup() {
	s = new_cstring();
}

void t_cstring_teardown() {
	free_cstring(s);
}

START(add)
	cstring_add(s, "Basic");
	assert_str("Add text to new cstring", "Basic", s->string);
	cstring_add(s, " check for spaces ");
	assert_str("Add text to already used cstring", 
		"Basic check for spaces ", s->string);
	cstring_add(s, "");
	assert_str("Check add of ampty string",
		"Basic check for spaces ", s->string);
END

START(add_mem)
	// 10M: a memory leak would hopefully be strucked if any
	for (size_t i = 0 ; i < 10000000 ; i++) {
		cstring_clear(s);
		cstring_add(s, str100); cstring_add(s, str100);
		cstring_add(s, str100); cstring_add(s, str100);
		cstring_add(s, str100); cstring_add(s, str100);
		cstring_add(s, str100); cstring_add(s, str100);
		cstring_add(s, str100); cstring_add(s, str100);
	}
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

