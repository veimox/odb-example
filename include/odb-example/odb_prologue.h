/**
 * As ODB is a piece of shit that cannot accept two profiles in the commmand
 * line and, as ODB is a piece of shit that force you to load all the boost
 * profiles  giving then problems with the smart pointer definitions AND as
 * eventhough if we could import the fucking boost profile, we cannot BECAUSE IT
 * DOES NOT EXIST IN THIS DEB FILE, then we have to create our own defining the
 * prologues. FUCK YOU ODB RELEASED WITH XENIAL.
 */

// All objects by default get the same version
#include "odb-example/version.h"
#if defined(DATABASE_MYSQL)
#include <odb/boost/date-time/mysql/posix-time-mapping.hxx>
#include <odb/boost/uuid/mysql/uuid-mapping.hxx>
#elif defined(DATABASE_SQLITE)
#include <odb/boost/date-time/sqlite/posix-time-mapping.hxx>
#include <odb/boost/uuid/sqlite/uuid-mapping.hxx>
#else
#error unknown database; did you forget to define the DATABASE_* macros?
#endif

// All strings by default are small
#include "odb-example/constants.h"
#pragma db value(std::string) type(VARCHAR_SMALL)
