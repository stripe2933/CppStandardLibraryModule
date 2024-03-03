cmake_minimum_required(VERSION 3.26.0 FATAL_ERROR)

# Check compiler support for C++23 Standard Library Module.
if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang" AND CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "17.0.0")
    if (CMAKE_CXX_STANDARD LESS 20)
        message(FATAL_ERROR "C++20 or newer is required.")
    endif()

    set(CMAKE_CXX_STANDARD_REQUIRED YES)
    set(CMAKE_CXX_EXTENSIONS OFF)

    add_compile_options($<$<COMPILE_LANGUAGE:CXX>:-nostdinc++>)
    add_compile_options($<$<COMPILE_LANGUAGE:CXX>:-isystem>)
    add_compile_options($<$<COMPILE_LANGUAGE:CXX>:${LIBCXX_BUILD}/include/c++/v1>)

    add_link_options($<$<COMPILE_LANGUAGE:CXX>:-nostdlib++>)
    add_link_options($<$<COMPILE_LANGUAGE:CXX>:-L${LIBCXX_BUILD}/lib>)
    add_link_options($<$<COMPILE_LANGUAGE:CXX>:-Wl,-rpath,${LIBCXX_BUILD}/lib>)

    include(FetchContent)
    FetchContent_Declare(
        std
        URL "file://${LIBCXX_BUILD}/modules/c++/v1/"
        DOWNLOAD_EXTRACT_TIMESTAMP TRUE
        SYSTEM
    )
    FetchContent_MakeAvailable(std)

    link_libraries(std c++)
    link_libraries(std.compat c++)
elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC" AND CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "19.36")
    if (CMAKE_CXX_STANDARD LESS 23)
        message(FATAL_ERROR "C++23 or newer is required.")
    endif()

    # Change Windows-specific path (use backslash) to Unix-style path (use forward slash).
    set(VCTOOLS_INSTALL_PATH ${VCTOOLS_INSTALL_DIR})
    string(REPLACE "\\" "/" VCTOOLS_INSTALL_PATH "${VCTOOLS_INSTALL_PATH}")

    include(FetchContent)
    FetchContent_Declare(
        std
        URL "file://${VCTOOLS_INSTALL_PATH}modules"
        DOWNLOAD_EXTRACT_TIMESTAMP TRUE
        SYSTEM
    )
    FetchContent_MakeAvailable(std)

    add_library(std)
    target_sources(std PUBLIC
        FILE_SET CXX_MODULES
        BASE_DIRS ${std_SOURCE_DIR}
        FILES
            ${std_SOURCE_DIR}/std.ixx
            ${std_SOURCE_DIR}/std.compat.ixx
    )

    link_libraries(std)
else()
    message(FATAL_ERROR "C++23 Standard library module is not supported with current compiler.")
endif()
