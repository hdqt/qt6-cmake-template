add_executable(DummyTest DummyTest.cpp)
target_link_libraries(DummyTest PRIVATE ${PROJECT_NAME}-gmock)
