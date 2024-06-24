/*
 * CUtils: some small C utilities
 *
 * Copyright (C) 2020 Niki Roo
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

#include <string.h>

#include "cutils.h"
#include "cstring.h"

#ifndef strnlen
size_t strnlen(const char *s, size_t maxlen) {
	size_t i;
	for (i = 0; s[i]; i++) {
		if (i >= maxlen)
			return maxlen;
	}

	return i;
}
#endif

#ifndef strdup
char *strdup(const char *source) {
	size_t sz = strlen(source);
	char *new = malloc((sz + 1) * sizeof(char));
	if (!new)
		return NULL;
	strcpy(new, source);
	return new;
}
#endif

#ifndef getline
ssize_t getline(char **strp, size_t *n, FILE *f) {
	char *str = *strp;
	size_t max = *n;
	ssize_t sz = 0;
	
	if (!str) {
		max = 1024;
		str = malloc(max);
	}
	
	int car = '\0';
	for (sz = 0 ; car >= 0 ; sz++) {
		int car = fgetc(f);
		if (car < 0)
			break;

		if (max <= sz) {
			max *= 2;
			str = realloc(str, max);
		}
		
		str[sz] = car;
		
		if (car == '\n')
			break;
	}
	
	if ((car < 0) && !sz)
		sz = -1;
	
	if (sz >= 0)
		str[sz] = '\0';
	
	*strp = str;
	*n = max;
	return sz;
}
#endif
