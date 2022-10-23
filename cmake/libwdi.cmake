
set(LIBWDI_DIR $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/../modules/libwdi/>$<INSTALL_INTERFACE:>)
add_library(libwdi STATIC)
add_library(libwdi::libwdi ALIAS libwdi)

# Generate the config file
if (MSVC)
    set(IS_MSVC 1)
else()
    set(IS_MSVC 0)
endif()
configure_file(${CMAKE_CURRENT_LIST_DIR}/config.h.in ${CMAKE_CURRENT_BINARY_DIR}/libwdi/config.h)
target_include_directories(libwdi PUBLIC ${CMAKE_CURRENT_BINARY_DIR}/libwdi)

# Any platform
target_sources(libwdi PRIVATE
        ${LIBWDI_DIR}/libwdi/embedder.c
        ${LIBWDI_DIR}/libwdi/installer.c
        ${LIBWDI_DIR}/libwdi/libwdi.c
        ${LIBWDI_DIR}/libwdi/libwdi_dlg.c
        ${LIBWDI_DIR}/libwdi/logging.c
        ${LIBWDI_DIR}/libwdi/pki.c
        ${LIBWDI_DIR}/libwdi/tokenizer.c
        ${LIBWDI_DIR}/libwdi/vid_data.c)

target_include_directories(libwdi PUBLIC ${LIBWDI_DIR}/libwdi)

install(
        TARGETS libwdi
        LIBRARY DESTINATION "lib"
        ARCHIVE DESTINATION "lib"
        RUNTIME DESTINATION "bin"
        INCLUDES DESTINATION "include"
)