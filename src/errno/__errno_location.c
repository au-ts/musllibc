#include <errno.h>
#include "pthread_impl.h"

static int errno_;

int *__errno_location(void)
{
	return &errno_;
}

weak_alias(__errno_location, ___errno_location);
