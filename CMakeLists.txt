cmake_minimum_required(VERSION 2.8.3)
project(odb-example)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)


###########
##  ODB  ##
###########
# Set policies
cmake_policy(SET CMP0053 OLD)
# Append cmake modules from source directory to the cmake module path
set(PACKAGE_PATH "${CMAKE_CURRENT_SOURCE_DIR}")
# Add the modules to the cmake path
list(APPEND CMAKE_MODULE_PATH "${PACKAGE_PATH}/cmake/Modules")
# Exposes custom methods
include(${PACKAGE_PATH}/cmake/Modules/Utils.cmake)
# Loads the database type from the yaml configuration
load_database_type("${PACKAGE_PATH}/config/config.yaml")
# Finds ODB for the specific database
find_package(ODB REQUIRED COMPONENTS
  ${DB_TYPE}
  boost
)
# Exposes odb
include(${ODB_USE_FILE})

odb_compile(
  ODB_OUTPUT
  FILES include/odb-example/objects.h
  DB ${DB_TYPE}
  STANDARD c++14
  FOREIGN_KEY not_deferrable
  SCHEMA_FORMAT embedded
  INCLUDE include ${catkin_INCLUDE_DIRS} ${OpenCV_INCLUDE_DIRS}
  GENERATE_QUERY GENERATE_SESSION GENERATE_SCHEMA
  CHANGELOG_DIR changelog
  AT_ONCE
  INPUT_NAME my-scheme
  DEFAULT_POINTER std::shared_ptr
  HEADER_PROLOGUE include/odb-example/hxx_prologue.h
  ODB_PROLOGUE include/odb-example/odb_prologue.h
  DATABASE_MACRO_DEFINITION ${DATABASE_MACRO}
  # SHOW_SLOC
)

###########
## Build ##
###########
include_directories(
  include
  include/odb-example
  ${ODB_INCLUDE_DIRS}
)

## Declare the executable
file(GLOB_RECURSE LIBRARY_SRC src/*.cpp)
add_executable(${PROJECT_NAME}
  ${LIBRARY_SRC}
  ${ODB_OUTPUT}
)
target_link_libraries(${PROJECT_NAME}
  ${ODB_LIBRARIES}
)
