#pragma once

#define VERSION 0x000002
#define BASE_VERSION 0x000001

#define VERSION_STATE open  // open if in developent, closed if release

#ifdef ODB_COMPILER
#pragma db model version(BASE_VERSION, VERSION, VERSION_STATE)
#endif
