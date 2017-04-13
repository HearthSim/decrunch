#define _CRT_SECURE_NO_WARNINGS
#include <string.h>
#if !defined(__APPLE__)
#include "malloc.h"
#ifdef _WIN32
#define malloc_usable_size _msize
#endif
#endif

#include "crn_decomp.h"
