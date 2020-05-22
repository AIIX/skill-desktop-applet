import QtQuick.Layouts 1.4
import QtQuick 2.4
import QtQuick.Controls 2.0
import org.kde.kirigami 2.4 as Kirigami
import Mycroft 1.0 as Mycroft

Item {
    id: "thinking"
    
    onVisibleChanged: {
        if(visible) {
            console.log("I am Visible")
            thinkLoader.enabled = true
        }
    }

    Loader {
        id: thinkLoader
        anchors.fill: parent
        enabled: false
        source: "ThinkAnim.qml"
        onStatusChanged: {
            console.log(status)
            if(thinkLoader.status === Loader.Error) {
                thinkLoader.source = "ThinkAnim.qml"
            }
        }
    }
}
