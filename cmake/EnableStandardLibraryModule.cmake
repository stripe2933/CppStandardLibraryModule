cmake_minimum_required(VERSION 3.26.0 FATAL_ERROR)

if (CMAKE_CXX_STANDARD LESS 23)
    message(FATAL_ERROR "C++23 or newer is required.")
endif()
set(CMAKE_CXX_STANDARD_REQUIRED YES)
set(CMAKE_CXX_EXTENSIONS OFF)

# Enable module feature in CMake.
if(CMAKE_VERSION VERSION_LESS "3.28.0")
    if(CMAKE_VERSION VERSION_LESS "3.27.0")
        set(CMAKE_EXPERIMENTAL_CXX_MODULE_CMAKE_API "2182bf5c-ef0d-489a-91da-49dbc3090d2a")
    else()
        set(CMAKE_EXPERIMENTAL_CXX_MODULE_CMAKE_API "aa1f7df0-828a-4fcd-9afc-2dc80491aca7")
    endif()
    set(CMAKE_EXPERIMENTAL_CXX_MODULE_DYNDEP 1)
else()
    cmake_policy(VERSION 3.28)
endif()

# Check compiler support for C++23 Standard Library Module.
if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang" AND CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "17.0.0")
    set(CMAKE_CXX_STANDARD_REQUIRED YES)
    set(CMAKE_CXX_EXTENSIONS OFF)

    include(FetchContent)
    FetchContent_Declare(
        std
        URL "file://${LIBCXX_BUILD}/modules/c++/v1/"
        DOWNLOAD_EXTRACT_TIMESTAMP TRUE
        SYSTEM
    )
    FetchContent_MakeAvailable(std)

    add_compile_options($<$<COMPILE_LANGUAGE:CXX>:-fprebuilt-module-path=${std_BINARY_DIR}/CMakeFiles/std.dir/>)
    add_compile_options($<$<COMPILE_LANGUAGE:CXX>:-fprebuilt-module-path=${std_BINARY_DIR}/CMakeFiles/std.compat.dir/>)
    add_compile_options($<$<COMPILE_LANGUAGE:CXX>:-nostdinc++>)
    add_compile_options($<$<COMPILE_LANGUAGE:CXX>:-isystem>)
    add_compile_options($<$<COMPILE_LANGUAGE:CXX>:${LIBCXX_BUILD}/include/c++/v1>)

    add_link_options($<$<COMPILE_LANGUAGE:CXX>:-nostdlib++>)
    add_link_options($<$<COMPILE_LANGUAGE:CXX>:-L${LIBCXX_BUILD}/lib>)
    add_link_options($<$<COMPILE_LANGUAGE:CXX>:-Wl,-rpath,${LIBCXX_BUILD}/lib>)

    link_libraries(std c++)
    link_libraries(std.compat c++)
elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC" AND CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "19.36")
    # For MSVC, Standard Library Module is automatically enabled for C++23.
else()
    message(FATAL_ERROR "C++23 Standard library module is not supported with current compiler.")
endif()
