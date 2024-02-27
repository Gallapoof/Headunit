
qt_add_library(aa STATIC)
qt_add_qml_module(
    aa
    URI "aa"
    VERSION 1.0
    RESOURCE_PREFIX "/qt/qml"
    SOURCES
        aalistener.h
        aalistener.cpp
    QML_FILES
)

target_link_libraries(aa PRIVATE Qt6::Quick libusb aasdk)