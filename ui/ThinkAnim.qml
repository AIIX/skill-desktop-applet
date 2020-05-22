import QtQuick.Layouts 1.4
import QtQuick 2.4
import QtQuick.Controls 2.0
import org.kde.kirigami 2.4 as Kirigami

AnimatedImage {
    id: thinkingGIF
    height: Math.min(parent.width, parent.height)
    anchors.centerIn: parent
    source: Qt.resolvedUrl("Animations/thinking.gif")
    fillMode: Image.PreserveAspectFit
    playing: true
}

