import QtQuick.Layouts 1.4
import QtQuick 2.4
import QtQuick.Controls 2.0
import org.kde.kirigami 2.5 as Kirigami
import Mycroft 1.0 as Mycroft

Mycroft.Delegate {
    id: idleLoaderView
    property var speak: sessionData.speak
    property var utterance: sessionData.query
    property bool speakInbound: sessionData.speakOutbound
    property bool utteranceInbound: sessionData.queryInbound
    property bool firstCheck: sessionData.firstCheck
    
    contentItem: Loader {
        id: rootLoader
        source: "conversation_view.qml"
    }
}
