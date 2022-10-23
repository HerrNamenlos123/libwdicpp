cmake_minimum_required(VERSION 3.16)
project(libwdicpp VERSION 0.1.1 LANGUAGES C CXX)

if (NOT WIN32)
    message(FATAL_ERROR "libwdi can only be built on windows! Make sure to use 'if (WIN32)' in your cmake project
        to only include this library on windows")
endif()

include(cmake/util.cmake)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_BINARY_DIR})
list(APPEND CMAKE_PREFIX_PATH ${CMAKE_BINARY_DIR})

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Choose Release or Debug" FORCE)
endif()

##################################
# Options: Library configuration #
##################################

option(LIBWDICPP_STATIC_RUNTIME "Use statically linked runtime" off)
option(LIBWDICPP_STATIC_LIB "Build shared library instead of static" off)
option(LIBWDICPP_BUILD_EXAMPLES "Build examples" on)
option(LIBWDICPP_VERBOSE_LOGGING "Enable internal verbose logging for debugging" off)


################
# Dependencies #
################

get_github_dependency(libwdi "modules/libwdi/Makefile.am" "https://github.com/pbatard/libwdi.git" v1.4.1)
include(cmake/libwdi.cmake)

#####################
# Target definition #
#####################

set(SOURCES
        ${CMAKE_CURRENT_LIST_DIR}/src/libwdicpp.cpp
        )

if (LIBWDICPP_STATIC_LIB)
    add_library(libwdicpp STATIC ${SOURCES})
else ()
    add_library(libwdicpp SHARED ${SOURCES})
endif ()

add_library(libwdicpp::libwdicpp ALIAS libwdicpp)
target_compile_features(libwdicpp PRIVATE cxx_std_17)
set_target_properties(libwdicpp PROPERTIES CXX_EXTENSIONS OFF)

target_include_directories(libwdicpp PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/include>
        $<INSTALL_INTERFACE:include>
        )

if(MSVC)
    string(APPEND CMAKE_CXX_FLAGS " /Zc:__cplusplus /MP")
else()
    target_compile_options(libwdicpp PRIVATE -Wno-psabi)
endif()

if (LIBWDICPP_VERBOSE_LOGGING)
    target_compile_definitions(libwdicpp PRIVATE LIBWDICPP_VERBOSE_LOGGING)
endif()
if (LIBWDICPP_STATIC_LIB)
    target_compile_definitions(libwdicpp PRIVATE LIBWDICPP_STATIC_LIB)
endif()

if (LIBWDICPP_STATIC_RUNTIME)
    use_static_runtime(libwdi)
    use_static_runtime(libwdicpp)
endif()

set_runtime_output_directory(libwdicpp ${CMAKE_CURRENT_BINARY_DIR}/bin)
set_archive_output_directory(libwdicpp ${CMAKE_CURRENT_BINARY_DIR}/bin)
set_library_output_directory(libwdicpp ${CMAKE_CURRENT_BINARY_DIR}/bin)

############################
# Preprocessor definitions #
############################

if (WIN32)
    target_compile_definitions(libwdicpp PRIVATE
            WIN32_LEAN_AND_MEAN      # Prevents Windows.h from adding unnecessary includes
            NOMINMAX                 # Prevents Windows.h from defining min/max as macros
            _CRT_SECURE_NO_WARNINGS
            )
    target_compile_definitions(libwdicpp PUBLIC
            UNICODE
            _UNICODE
            )
endif()






###########
# Linking #
###########

target_link_libraries(libwdicpp libwdi)



############
# Examples #
############

if (LIBWDICPP_BUILD_EXAMPLES)
    add_subdirectory(examples)
endif()



###########
# Install #
###########

#include(CMakePackageConfigHelpers)
#write_basic_package_version_file(
#    libusbcppConfigVersion.cmake
#    VERSION ${PACKAGE_VERSION}
#    COMPATIBILITY AnyNewerVersion
#)
#
## Install binaries
#install(
#    TARGETS Battery
#    EXPORT BatteryTargets
#    LIBRARY DESTINATION "lib"
#    ARCHIVE DESTINATION "lib"
#    RUNTIME DESTINATION "bin"
#    INCLUDES DESTINATION "include"
#)
#
## Install headers
#install(
#    DIRECTORY include/
#    DESTINATION "include"
#    FILES_MATCHING PATTERN "*.h*"
#)
#
#install(
#    EXPORT BatteryTargets
#    DESTINATION "lib/cmake/Battery"
#    NAMESPACE Battery::
#)
#
## Install Targets
#configure_file(cmake/BatteryConfig.cmake.in BatteryConfig.cmake @ONLY)
#install(
#    FILES "${CMAKE_CURRENT_BINARY_DIR}/BatteryConfig.cmake"
#          "${CMAKE_CURRENT_BINARY_DIR}/BatteryConfigVersion.cmake"
#    DESTINATION lib/cmake/Battery
#)
