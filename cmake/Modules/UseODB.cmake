
set(ODB_COMPILE_DEBUG FALSE)
set(ODB_COMPILE_OUTPUT_DIR "${CMAKE_CURRENT_BINARY_DIR}/odb_gen")
set(ODB_COMPILE_HEADER_SUFFIX ".h")
set(ODB_COMPILE_INLINE_SUFFIX "_inline.h")
set(ODB_COMPILE_SOURCE_SUFFIX ".cpp")
set(ODB_COMPILE_FILE_SUFFIX "_odb")
set(ODB_COMPILE_SEPARATE_SCHEMA_SUFFIX "-schema")

set(CMAKE_INCLUDE_CURRENT_DIR TRUE)

function(odb_compile outvar)
	if(NOT ODB_EXECUTABLE)
		message(FATAL_ERROR "odb compiler executable not found")
	endif()

  set(options GENERATE_QUERY GENERATE_SESSION GENERATE_SCHEMA GENERATE_PREPARED AT_ONCE SHOW_SLOC)
  set(oneValueParams SCHEMA_FORMAT SCHEMA SCHEMA_NAME TABLE_PREFIX
		STANDARD SLOC_LIMIT
		HEADER_PROLOGUE INLINE_PROLOGUE SOURCE_PROLOGUE
		HEADER_EPILOGUE INLINE_EPILOGUE SOURCE_EPILOGUE
		MULTI_DATABASE
    PROFILE
    FOREIGN_KEY
    ODB_COMPILE_OUTPUT_DIR_OVERRIDE
    ODB_PROLOGUE
    CHANGELOG_DIR
    INPUT_NAME
    INCLUDE_PREFIX
    INCLUDE_REGEX
    DEFAULT_POINTER
    DATABASE_MACRO_DEFINITION
    )
	set(multiValueParams FILES INCLUDE DB)

	cmake_parse_arguments(PARAM "${options}" "${oneValueParams}" "${multiValueParams}" ${ARGN})

	if(PARAM_UNPARSED_ARGUMENTS)
		message(FATAL_ERROR "invalid arguments passed to odb_wrap_cpp: ${PARAM_UNPARSED_ARGUMENTS}")
	endif()

	if(NOT PARAM_FILES)
		message(FATAL_ERROR: "no input files to odb_compile")
	endif()

	set(ODB_ARGS)

	if(PARAM_MULTI_DATABASE)
		list(APPEND ODB_ARGS --multi-database "${PARAM_MULTI_DATABASE}")
		list(APPEND PARAM_DB common)
	endif()

	foreach(db ${PARAM_DB})
    list(APPEND ODB_ARGS --database "${db}")
  endforeach()

  if(PARAM_PROFILE)
    list(APPEND ODB_ARGS --profile ${PARAM_PROFILE})
  endif()

  if(PARAM_DATABASE_MACRO_DEFINITION)
    list(APPEND ODB_ARGS -D${PARAM_DATABASE_MACRO_DEFINITION})
  endif()

	if(PARAM_GENERATE_QUERY)
		list(APPEND ODB_ARGS --generate-query)
  endif()

  if(PARAM_DEFAULT_POINTER)
    list(APPEND ODB_ARGS --default-pointer "${PARAM_DEFAULT_POINTER}")
  endif()

	if(PARAM_GENERATE_SESSION)
		list(APPEND ODB_ARGS --generate-session)
	endif()

	if(PARAM_GENERATE_SCHEMA)
		list(APPEND ODB_ARGS --generate-schema)
	endif()

	if(PARAM_GENERATE_PREPARED)
		list(APPEND ODB_ARGS --generate-prepared)
  endif()

  if(PARAM_AT_ONCE)
    list(APPEND ODB_ARGS --at-once)
  endif()

	if(PARAM_SCHEMA_FORMAT)
    list(APPEND ODB_ARGS --schema-format "${PARAM_SCHEMA_FORMAT}")
	endif()

	if(PARAM_SCHEMA_NAME)
		list(APPEND ODB_ARGS --schema-name "${PARAM_SCHEMA_NAME}")
  endif()

  if(PARAM_SCHEMA)
    list(APPEND ODB_ARGS --schema "${PARAM_SCHEMA}")
  endif()

	if(PARAM_TABLE_PREFIX)
		list(APPEND ODB_ARGS --table-prefix "${PARAM_TABLE_PREFIX}")
	endif()

	if(PARAM_STANDARD)
		list(APPEND ODB_ARGS --std "${PARAM_STANDARD}")
	endif()

	if(PARAM_SLOC_LIMIT)
		list(APPEND ODB_ARGS --sloc-limit "${PARAM_SLOC_LIMIT}")
  endif()

  if(PARAM_SHOW_SLOC)
    list(APPEND ODB_ARGS --show-sloc)
  endif()

	if(PARAM_HEADER_PROLOGUE)
		list(APPEND ODB_ARGS --hxx-prologue-file "${PARAM_HEADER_PROLOGUE}")
  endif()

  if(PARAM_ODB_PROLOGUE)
    list(APPEND ODB_ARGS --odb-prologue-file "${PARAM_ODB_PROLOGUE}")
  endif()

  if(PARAM_CHANGELOG_DIR)
    list(APPEND ODB_ARGS --changelog-dir "${PARAM_CHANGELOG_DIR}")
  endif()

  if(PARAM_INPUT_NAME)
    list(APPEND ODB_ARGS --input-name "${PARAM_INPUT_NAME}")
  endif()

  if(PARAM_INCLUDE_PREFIX)
    list(APPEND ODB_ARGS --include-prefix "${PARAM_INCLUDE_PREFIX}")
  endif()

  if(PARAM_INCLUDE_REGEX)
    list(APPEND ODB_ARGS --include-regex "${PARAM_INCLUDE_REGEX}")
  endif()

  if(PARAM_DEFAULT_POINTER)
    list(APPEND ODB_ARGS --default-pointer "${PARAM_DEFAULT_POINTER}")
  endif()

	if(PARAM_INLINE_PROLOGUE)
		list(APPEND ODB_ARGS --ixx-prologue-file "${PARAM_INLINE_PROLOGUE}")
	endif()

	if(PARAM_SOURCE_PROLOGUE)
		list(APPEND ODB_ARGS --cxx-prologue-file "${PARAM_SOURCE_PROLOGUE}")
	endif()

	if(PARAM_HEADER_EPILOGUE)
		list(APPEND ODB_ARGS --hxx-epilogue-file "${PARAM_HEADER_EPILOGUE}")
	endif()

	if(PARAM_INLINE_EPILOGUE)
		list(APPEND ODB_ARGS --ixx-epilogue-file "${PARAM_INLINE_EPILOGUE}")
	endif()

  if(PARAM_SOURCE_EPILOGUE)
    list(APPEND ODB_ARGS --cxx-epilogue-file "${PARAM_SOURCE_EPILOGUE}")
  endif()

  if(PARAM_ODB_PROLOGE)
    list(APPEND ODB_ARGS --odb-prologue "${PARAM_ODB_PROLOGE}")
  endif()

  if(PARAM_HXX_PROLOGE)
    list(APPEND ODB_ARGS --hxx-prologue "${PARAM_HXX_PROLOGE}")
  endif()

  if(PARAM_FOREIGN_KEY)
    list(APPEND ODB_ARGS --fkeys-deferrable-mode "${PARAM_FOREIGN_KEY}")
  endif()

  if(PARAM_ODB_COMPILE_OUTPUT_DIR_OVERRIDE)
    set(ODB_COMPILE_OUTPUT_DIR "${PARAM_ODB_COMPILE_OUTPUT_DIR_OVERRIDE}")
  endif()

	list(APPEND ODB_ARGS --output-dir "${ODB_COMPILE_OUTPUT_DIR}")
	list(APPEND ODB_ARGS --hxx-suffix "${ODB_COMPILE_HEADER_SUFFIX}")
	list(APPEND ODB_ARGS --ixx-suffix "${ODB_COMPILE_INLINE_SUFFIX}")
	list(APPEND ODB_ARGS --cxx-suffix "${ODB_COMPILE_SOURCE_SUFFIX}")

	if(PARAM_MULTI_DATABASE AND NOT "${ODB_COMPILE_FILE_SUFFIX}" MATCHES ".+:.+")
		set(osuffix "${ODB_COMPILE_FILE_SUFFIX}")
		set(ODB_COMPILE_FILE_SUFFIX)
		foreach(db ${PARAM_DB})
			if("${db}" MATCHES "common")
				list(APPEND ODB_COMPILE_FILE_SUFFIX "${db}:${osuffix}")
			else()
				list(APPEND ODB_COMPILE_FILE_SUFFIX "${db}:${osuffix}_${db}")
			endif()
		endforeach()
	endif()

	foreach(sfx ${ODB_COMPILE_FILE_SUFFIX})
		list(APPEND ODB_ARGS --odb-file-suffix "${sfx}")
	endforeach()

	foreach(dir ${PARAM_INCLUDE} ${ODB_INCLUDE_DIRS})
		list(APPEND ODB_ARGS "-I${dir}")
	endforeach()

  # Cleans and makes the odb output dir
#	file(REMOVE_RECURSE "${ODB_COMPILE_OUTPUT_DIR}")
  file(MAKE_DIRECTORY "${ODB_COMPILE_OUTPUT_DIR}")

  # Check if the db format is separate, then the output var is the name
  # of the given separate format
  if("${PARAM_SCHEMA_FORMAT}" MATCHES "separate")

    # Add the output separed file
    set(output "${ODB_COMPILE_OUTPUT_DIR}/${PARAM_INPUT_NAME}${ODB_COMPILE_FILE_SUFFIX}${ODB_COMPILE_SOURCE_SUFFIX}")
    list(APPEND ${outvar} "${output}")
    list(APPEND outputs "${output}")
    # Add the scheme separed file
    set(output "${ODB_COMPILE_OUTPUT_DIR}/${PARAM_INPUT_NAME}${ODB_COMPILE_SEPARATE_SCHEMA_SUFFIX}${ODB_COMPILE_SOURCE_SUFFIX}")
    list(APPEND ${outvar} "${output}")
    list(APPEND outputs "${output}")

    # Compilation method
    add_custom_command(OUTPUT ${outputs}
      COMMAND ${ODB_EXECUTABLE} ${ODB_ARGS} ${PARAM_FILES}
      WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
      VERBATIM)
  # If not, the output var are the names of the objects with the prefixes
  elseif("${PARAM_SCHEMA_FORMAT}" MATCHES "embedded" )
    # Add the output separed file
    set(output "${ODB_COMPILE_OUTPUT_DIR}/${PARAM_INPUT_NAME}${ODB_COMPILE_FILE_SUFFIX}${ODB_COMPILE_SOURCE_SUFFIX}")
    list(APPEND ${outvar} "${output}")
    list(APPEND outputs "${output}")
    # Compilation method
    add_custom_command(OUTPUT ${outputs}
      COMMAND ${ODB_EXECUTABLE} ${ODB_ARGS} ${PARAM_FILES}
      WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
      VERBATIM)
  # If not, the output var are the names of the objects with the prefixes
  else()
    foreach(input ${PARAM_FILES})
      # Sets the name correctly
      get_filename_component(fname "${input}" NAME_WE)
      set(outputs)
      foreach(sfx ${ODB_COMPILE_FILE_SUFFIX})
        string(REGEX REPLACE ":.*$" "" pfx "${sfx}")
        string(REGEX REPLACE "^.*:" "" sfx "${sfx}")

        # If is not a multi database static, append all the files into
        # ouput and outvar
        if(NOT "${PARAM_MULTI_DATABASE}" MATCHES "static" OR NOT "${pfx}" MATCHES "common")
          set(output "${ODB_COMPILE_OUTPUT_DIR}/${fname}${sfx}${ODB_COMPILE_SOURCE_SUFFIX}")
          list(APPEND ${outvar} "${output}")
          list(APPEND outputs "${output}")
        endif()
      endforeach()

      # Compilation method
      add_custom_command(OUTPUT ${outputs}
        COMMAND ${ODB_EXECUTABLE} ${ODB_ARGS} "${input}"
        DEPENDS "${input}"
        WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
        VERBATIM)
    endforeach()
  endif()


  # If debug
  if(ODB_COMPILE_DEBUG)
    set(_msg "${ODB_EXECUTABLE} ${ODB_ARGS} ${input}")
    string(REPLACE ";" " " _msg "${_msg}")
    message(STATUS "${_msg}")
  endif()
  # Set the output as a variable in the Parent CMakeList
	set(${outvar} ${${outvar}} PARENT_SCOPE)
endfunction()
