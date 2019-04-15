#define _CRT_SECURE_NO_WARNINGS

#include <string.h>

#if !defined(__APPLE__)
#if defined(__FreeBSD__)
#include <stdlib.h>
#else
#include <malloc.h>
#endif
#ifdef _WIN32
#define malloc_usable_size _msize
#endif
#endif

#include "crn_decomp.h"
