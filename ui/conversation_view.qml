import QtQuick.Layouts 1.4
import QtQuick 2.4
import QtQuick.Controls 2.0
import org.kde.kirigami 2.5 as Kirigami
import org.kde.plasma.core 2.0 as PlasmaCore
import Mycroft 1.0 as Mycroft

Item {
    id: root
    anchors.fill: parent
    property var incomingUtterance: idleLoaderView.utterance
    property var incomingMessage: idleLoaderView.speak
    property bool incomingUtteranceInbound: idleLoaderView.queryInbound
    property bool incomingMessageInbound: idleLoaderView.speakInbound
    
    onIncomingMessageChanged: {
        if(incomingMessage !== ""){
            Mycroft.MycroftController.sendRequest("skill.desktop.applet.prevMessage", {"previousMessage": incomingMessage})
            pushMessage(incomingUtterance, incomingUtteranceInbound)
            pushMessage(incomingMessage, incomingMessageInbound)
        }
    }
    
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
    
    ListView {
        id: mainView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
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
}
