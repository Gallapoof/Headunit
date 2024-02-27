cmake_minimum_required(VERSION 3.22)

project(HeadunitApp LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${PROJECT_SOURCE_DIR}/cmake_modules/")

find_package(Qt6 6.2 COMPONENTS Core Quick Gui Qml REQUIRED)

qt_add_executable(HeadunitApp
    src/main.cpp
)

include_directories(../aasdk/include)

target_link_libraries(HeadunitApp PRIVATE 
    Qt6::Core
    Qt6::Gui 
    Qt6::Quick 
    Qt6::Qml
)

qt_add_qml_module(HeadunitApp
    URI "Main"
    VERSION 1.0
    RESOURCE_PREFIX "/qt/qml"
    NO_PLUGIN
    QML_FILES src/main.qml
)

add_subdirectory(content)

add_subdirectory(../aasdk/ ./aasdk)

add_subdirectory(aa)

target_link_libraries(HeadunitApp PRIVATE contentplugin aaplugin)