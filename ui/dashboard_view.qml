import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.5 as Kirigami
import QtGraphicalEffects 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import Mycroft 1.0 as Mycroft
import QtQml 2.2

Item {
    id: root
    anchors.fill: parent
    
    PlasmaCore.DataSource {
        id: geoDataSource
        engine: "time"
        connectedSources: ["Local", "UTC"]
        interval: 10000
            
        onNewData: {
            interval = 100000
            if (sourceName == "Local") {
                dayNameLabel.text = data.DateTime
            }
        }
    }
    
    ColumnLayout {
        anchors.fill: parent
        
        RowLayout {
            Layout.fillWidth: true
            
            Kirigami.Icon {
                id: dayShapeIcon
                Layout.preferredWidth: Kirigami.Units.iconSizes.smallMedium
                Layout.preferredHeight: Kirigami.Units.iconSizes.smallMedium
                source: "draw-ellipse-whole"
            }
            
            Kirigami.Heading {
                id: dayNameLabel
                Layout.fillWidth: true
                level: 1
                font.weight: Font.Bold
            }
        }
        
        PlasmaCore.SvgItem {
            Layout.fillWidth: true
            Layout.preferredHeight: horlineSvg2.elementSize("horizontal-line").height

            elementId: "horizontal-line"
            svg: PlasmaCore.Svg {
                id: horlineSvg2;
                imagePath: "widgets/line"
            }
        }
        
        RowLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.largeSpacing
           
            Kirigami.Heading {
                id: categoryLabel
                level: 2
                text: "News"
                Layout.alignment: Qt.AlignTop
                font.weight: Font.Medium
                Layout.preferredWidth: Kirigami.Units.gridUnit * 2
            }
            
            PlasmaCore.SvgItem {
                id: topbarDividerline
                Layout.fillHeight: true
                Layout.preferredWidth: linetopvertSvg.elementSize("vertical-line").width
                elementId: "vertical-line"

                svg: PlasmaCore.Svg {
                    id: linetopvertSvg;
                    imagePath: "widgets/line"
                }
            }
            
            Kirigami.CardsListView {
                id: newsListView
                model: mainLoaderView.newsModel.articles
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                //minimumColumnWidth: Kirigami.Units.gridUnit * 10
                //maximumColumnWidth: Kirigami.Units.gridUnit * 15
                delegate: Kirigami.AbstractCard{
                    id: cardNewsItem
                    showClickFeedback: true
                    implicitHeight: Kirigami.Units.gridUnit * 25
                    property bool expanded: false
                    contentItem: Item {
                        implicitWidth: parent.implicitWidth
                        implicitHeight: parent.implicitHeight
                        
                    ColumnLayout {
                        id: delegateItem
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        spacing: Kirigami.Units.smallSpacing

                        Kirigami.Heading {
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                            level: 3
                            text: qsTr(modelData.title)
                        }
                        
                        Image {
                            Layout.fillWidth: true
                            Layout.preferredHeight: root.height / 4
                            source: modelData.urlToImage
                            fillMode: Image.PreserveAspectCrop
                            Component.onCompleted: {
                                if(source == ""){
                                    source = "https://www.890kdxu.com/wp-content/uploads/2017/05/News_placeholder-image.jpg"
                                }
                            }
                        }
                        
                        Label {
                            id: newsDescriptionLabel
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                            visible: false
                            Component.onCompleted: {
                                if(modelData.content == ""){
                                    text = modelData.title;
                                }
                                else {
                                    text = modelData.content.substr(0, modelData.content.lastIndexOf("["));
                                    }
                                }
                            }
                        
                            PlasmaCore.SvgItem {
                                Layout.fillWidth: true
                                Layout.preferredHeight: horlineSvg2.elementSize("horizontal-line").height

                                elementId: "horizontal-line"
                                svg: PlasmaCore.Svg {
                                    id: horlineSvg2;
                                    imagePath: "widgets/line"
                                }
                            }
                            
                            Item {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Kirigami.Units.gridUnit * 2
                            
                                Kirigami.Icon {
                                    id: expandableIcon
                                    anchors.centerIn: parent
                                    source: "go-down"
                                    width: Kirigami.Units.iconSizes.smallMedium
                                    height: Kirigami.Units.iconSizes.smallMedium
                                }
                            }
                        }
                    }
                    
                onClicked: {
                        if(!expanded){
                            expanded = true
                            newsDescriptionLabel.visible = true
                            expandableIcon.source = "go-up"
                        }
                        else if(expanded){
                            expanded = false
                            newsDescriptionLabel.visible = false
                            expandableIcon.source = "go-down"
                        }
                    }
                }
            }
        }
    }
}
