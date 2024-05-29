set(PUBLIC_LIBRARIES_TO_LINK
    Qt6::Quick
)

if (BUILD_SHARED_LIBS)
    add_library(${PROJECT_NAME} SHARED)
    target_link_libraries(${PROJECT_NAME} PUBLIC ${PUBLIC_LIBRARIES_TO_LINK})
endif()

add_library(lib${PROJECT_NAME} STATIC)
target_link_libraries(lib${PROJECT_NAME} PUBLIC ${PUBLIC_LIBRARIES_TO_LINK})

if (BUILD_UNIT_TESTS)
    add_library(${PROJECT_NAME}-gmock SHARED)
    target_link_libraries(${PROJECT_NAME}-gmock PUBLIC gtest::gtest lib${PROJECT_NAME})
endif()

add_subdirectory(api)
add_subdirectory(src)
add_subdirectory(res)

if (BUILD_UNIT_TESTS)
    add_subdirectory(gmock)
    add_subdirectory(test)
endif()
