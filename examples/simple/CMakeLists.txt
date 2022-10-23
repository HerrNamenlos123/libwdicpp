cmake_minimum_required(VERSION 3.16)
project(simple)

add_executable(simple simple.cpp)

target_compile_features(simple PRIVATE cxx_std_17)
set_target_properties(simple PROPERTIES CXX_EXTENSIONS OFF)

if (LIBWDICPP_STATIC_RUNTIME)
    use_static_runtime(simple)
endif()

target_link_libraries(simple libwdicpp)

set_runtime_output_directory(simple ${CMAKE_BINARY_DIR}/bin)

install(
        TARGETS simple
        LIBRARY DESTINATION "lib"
        ARCHIVE DESTINATION "lib"
        RUNTIME DESTINATION "bin"
        INCLUDES DESTINATION "include"
)