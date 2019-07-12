#pragma once

#include <string>

/*
 * Constants definition. Defining some constants as both defines and normal
 * variables to, as a general rule, use the const ones but and for ODB the
 * defines
 */
#define VARCHAR_SMALL "VARCHAR(255)"
#define VARCHAR_MEDIUM "VARCHAR(4096)"
#define VARCHAR_BIG "VARCHAR(8192)"

namespace ODBExample {
const unsigned int small_varchar = 255;
const unsigned int medium_varchar = 4096;
const unsigned int big_varchar = 8192;

}  // namespace ODBExample
