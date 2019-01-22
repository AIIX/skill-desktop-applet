import QtQuick.Layouts 1.4
import QtQuick 2.4
import QtQuick.Controls 2.0
import org.kde.kirigami 2.5 as Kirigami
import org.kde.plasma.core 2.0 as PlasmaCore
import Mycroft 1.0 as Mycroft

Item {
    id: root
    anchors.fill: parent
    
    function pushMessage(text, inbound) {
        conversationModel.append({"text": text, "inbound": inbound});
        if (conversationModel.count > 20) {
            conversationModel.remove(0)
        }
        mainView.flick(0, -500);
    }
    
    Component.onCompleted: {
        pushMessage(i18n("How can I help you?"), false);
    }
    
    Connections {
        id: mycroftConnection
        target: Mycroft.MycroftController
        onFallbackTextRecieved: {
            pushMessage(data.utterance, true);
        }
    }
    
    ListView {
        id: mainView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: bottomSuggestBox.top
        spacing: Kirigami.Units.largeSpacing
        topMargin: Math.max(0, height - contentHeight - Kirigami.Units.largeSpacing * 3)
        bottomMargin: Kirigami.Units.largeSpacing
        anchors.margins: Kirigami.Units.largeSpacing
        clip: true
        model: ListModel {
                    id: conversationModel
        }
        delegate: ConversationDelegate {}
    }
    
    Suggestions {
        id: bottomSuggestBox
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: -1 * Kirigami.Units.largeSpacing
        anchors.rightMargin: -1 * Kirigami.Units.largeSpacing
        anchors.right: parent.right
        height: Kirigami.Units.gridUnit * 2
    }
}
