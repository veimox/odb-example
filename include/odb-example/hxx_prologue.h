/**
 * As ODB is a piece of shit that cannot accept two profiles in the commmand
 * line and, as ODB is a piece of shit that force you to load all the boost
 * profiles  giving then problems with the smart pointer definitions AND as
 * eventhough if we could import the fucking boost profile, we cannot BECAUSE IT
 * DOES NOT EXIST IN THIS DEB FILE, then we have to create our own defining the
 * prologues. FUCK YOU ODB.
 */

#if defined(DATABASE_MYSQL)
#include <odb/boost/date-time/mysql/posix-time-traits.hxx>
#include <odb/boost/uuid/mysql/uuid-traits.hxx>
#elif defined(DATABASE_SQLITE)
#include <odb/boost/date-time/sqlite/posix-time-traits.hxx>
#include <odb/boost/uuid/sqlite/uuid-traits.hxx>
#else
#error unknown database; did you forget to define the DATABASE_* macros?
#endif
#include <odb/boost/version.hxx>
