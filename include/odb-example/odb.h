#pragma once

// ODB
#include <odb/lazy-ptr.hxx>
#include "odb_gen/my-scheme_odb.h"
#if defined(DATABASE_MYSQL)
#include <odb/mysql/database.hxx>
#include <odb/mysql/exceptions.hxx>
#elif defined(DATABASE_SQLITE)
#include <odb/connection.hxx>
#include <odb/schema-catalog.hxx>
#include <odb/sqlite/database.hxx>
#else
#error unknown database; did you forget to define the DATABASE_* macros?
#endif

#include <odb/schema-catalog.hxx>
#include <odb/transaction.hxx>
