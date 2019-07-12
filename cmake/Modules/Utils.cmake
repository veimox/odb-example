# Reads the given file, finds the database and acts
function(load_database_type file)
  # Read the file and find "db_type: " option
  file(STRINGS "${file}" CONFIG)
  foreach(LINE ${CONFIG})
    string(REGEX MATCH "db_type: (.*)" DB_TYPE_LINE ${LINE})
    if (NOT ${DB_TYPE_LINE} STREQUAL "")
      string(REGEX REPLACE "db_type: (.*)" "\\1" DB_TYPE ${DB_TYPE_LINE})
    endif()
  endforeach()
  if (${DB_TYPE} STREQUAL "")
    message(FATAL_ERROR "${DB_TYPE}")
  endif()

  # Check that the db is supported
  set(DATABASE_MACRO "")
  if(${DB_TYPE} STREQUAL "mysql")
    message (STATUS "Using MySQL")
    set(DATABASE_MACRO DATABASE_MYSQL)
  elseif(${DB_TYPE} STREQUAL "sqlite")
    message (STATUS "Using SqLite")
    set(DATABASE_MACRO DATABASE_SQLITE)
  else()
    message (FATAL_ERROR "Database type not recognized. Use 'mysql' or 'sqlite'.")
  endif()

  # Set in parent scope and add the flag
  set(DB_TYPE ${DB_TYPE} PARENT_SCOPE)
  set(DATABASE_MACRO ${DATABASE_MACRO} PARENT_SCOPE)
  add_definitions("-D${DATABASE_MACRO}")
endfunction()
