# cmakelibrary

This is a personal library of CMake functions and macros. It is not intended to be a comprehensive CMake library, 
but rather a collection that I use in my own projects.

Here's how I reuse the CMake functions and macros in my projects:

```
function(FetchAndIncludeCMakeHelper)
    include(FetchContent)
    # Fetch my public repo
    FetchContent_Declare(
        cmakehelperproject
        GIT_REPOSITORY https://github.com/philippesanchescotch/cmakelibrary.git
    )
    FetchContent_MakeAvailable(cmakehelperproject)

    # Add fetched repo to our module path
    list(APPEND CMAKE_MODULE_PATH ${cmakehelperproject_SOURCE_DIR}/cmakehelper/)
    message(STATUS "Add cmakehelperproject_SOURCE_DIR to module path" CMAKE_MODULE_PATH="${CMAKE_MODULE_PATH}")

    include(cmakehelper)
endfunction()

# Clone the repo and include it.
FetchAndIncludeCMakeHelper()

# Now call any function from cmakehelper.cmake directly, for instance
SetupCompilerFlags()
```
