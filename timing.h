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

/** 
 * @file timing.h
 * @author Niki
 * @date 2020 - 2024
 *
 * @brief Timing macros TIMING_START and TIMING_STOP
 *
 * 2 macro are provided to print the elapsed time between the 2 to stdout.
 */

#ifndef TIMING_H
#define TIMING_H

#ifdef __cplusplus
extern "C" {
#endif

#include <sys/time.h>
#include <stdio.h>

typedef struct {
	struct timeval start;
	struct timeval stop;
	size_t sec;
	int msec;
	int usec;
} timing_t;

/**
 * Start the timing.
 */
#define TIMING_START(timing) \
	timing_t timing; \
	gettimeofday(&(timing.start), NULL); \
	timing.sec = timing.msec = timing.usec = 0; \
	timing.stop.tv_sec = 0; \
	timing.stop.tv_usec = 0; \
while(0)

/**
 * Stop the timing and return the elapsed time in milliseconds into msec.
 */
#define TIMING_STOP(timing) \
	gettimeofday(&(timing.stop), NULL); \
	if (timing.stop.tv_usec >= timing.start.tv_usec) { \
		timing.sec = timing.stop.tv_sec - timing.start.tv_sec; \
		timing.usec = timing.stop.tv_usec - timing.start.tv_usec; \
	} else { \
		timing.sec = (timing.stop.tv_sec - timing.start.tv_sec) - 1; \
		timing.usec = timing.start.tv_usec - timing.stop.tv_usec; \
	} \
	timing.msec = timing.usec / 1000; \
	timing.usec = timing.usec % 1000; \
	gettimeofday(&(timing.start), NULL); \
while(0)

/**
 * Stop the timing and print the elapsed time.
 */
#define TIMING_PRINT(timing) \
	TIMING_STOP(timing); \
	printf("TIME: %zu.%03d%03d sec\n", \
		timing.sec, timing.msec, timing.usec); \
while(0)

#endif // TIMING_H

#ifdef __cplusplus
}
#endif

