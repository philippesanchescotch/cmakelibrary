# Make sure we have CMP0011 NEW to avoid a warning from CMP0054.
# We want the policies to not affect the includer.
cmake_policy(VERSION 3.31.6)
# "MSVC" comparison will fail if quoted variables get expanded.
cmake_policy(SET CMP0054 NEW)

function(SetupCMake)
    set(CMAKE_CXX_STANDARD_REQUIRED ON CACHE INTERNAL "")
    set(CMAKE_CXX_STANDARD 23 CACHE INTERNAL "")

    find_package(Git REQUIRED)

    message(STATUS CMAKE_CXX_COMPILER_FRONTEND_VARIANT="${CMAKE_CXX_COMPILER_FRONTEND_VARIANT}")
    message(STATUS CMAKE_CXX_COMPILER_ID="${CMAKE_CXX_COMPILER_ID}")
    message(STATUS CMAKE_CXX_COMPILER="${CMAKE_CXX_COMPILER}")
    message(STATUS CMAKE_CXX_STANDARD="${CMAKE_CXX_STANDARD}")
endfunction()

function(SetupCompilerFlags)
    set (BASE_C_CXX_ADDITIONAL_FLAGS "")
    set (BASE_C_CXX_DISABLED_FLAGS "")

    # Clang-cl, clang, gcc common options
    if(NOT CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
        set (BASE_C_CXX_ADDITIONAL_FLAGS "-Wnull-dereference -Wdouble-promotion -Wshadow")
        set (BASE_C_CXX_DISABLED_FLAGS "-Wno-unused-parameter")
    endif()

    set (BASE_C_CXX_FLAGS " ${BASE_C_CXX_ADDITIONAL_FLAGS} ${BASE_C_CXX_DISABLED_FLAGS}")

    # Clang-cl
    if(CMAKE_CXX_COMPILER_FRONTEND_VARIANT STREQUAL "MSVC" AND NOT CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
        # Don't use Wall here for all cases, for clang/cl it would convert to Weverything.
        set (CMAKE_CXX_FLAGS "${BASE_C_CXX_FLAGS} /Zi /W4" CACHE INTERNAL "")
        set (CMAKE_C_FLAGS "${BASE_C_CXX_FLAGS} /Zi /W4" CACHE INTERNAL "")
        message(STATUS "Setting clang-cl options " CMAKE_CXX_FLAGS="${CMAKE_CXX_FLAGS}")
        # Msvc
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
        set (CMAKE_CXX_FLAGS "${BASE_C_CXX_FLAGS} /Zi /W4 /EHsc" CACHE INTERNAL "")
        set (CMAKE_C_FLAGS "${BASE_C_CXX_FLAGS} /Zi /W4 /EHsc" CACHE INTERNAL "")
        message(STATUS "Setting msvc options " CMAKE_CXX_FLAGS="${CMAKE_CXX_FLAGS}")
        # Clang, gcc
    else ()
        set (CMAKE_CXX_FLAGS "${BASE_C_CXX_FLAGS} -Wall" CACHE INTERNAL "" )
        set (CMAKE_C_FLAGS "${BASE_C_CXX_FLAGS} -Wall" CACHE INTERNAL "" )
        message(STATUS "Setting gcc/clang options " CMAKE_CXX_FLAGS="${CMAKE_CXX_FLAGS}")
    endif()
endfunction()

function(SetupAdditionalLibs argProjectName)
    # Check for use case SetupAdditionalLibs("")
    if (argProjectName STREQUAL "")
        message( FATAL_ERROR "Please specify a valid 'argProjectName' argument." )
    endif()
    # Check for use case
    # set(patate "")
    # SetupAdditionalLibs(patate)
    if (${argProjectName} STREQUAL "")
        message( FATAL_ERROR "Please specify a valid 'argProjectName' argument." )
    endif()

    if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        message(STATUS "Adding stdc++exp to linker options (-l) for project: ${argProjectName}")
        target_link_libraries(${argProjectName} stdc++exp)
    endif()
endfunction()


