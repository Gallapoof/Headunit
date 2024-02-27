qt_add_library(content STATIC)
qt_add_qml_module(
    content
    URI "content"
    VERSION 1.0
    RESOURCE_PREFIX "/qt/qml"
    QML_FILES
        App.qml
        HomeScreen.qml
        
)