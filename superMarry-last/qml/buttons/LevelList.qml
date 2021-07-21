/*
 * 时间：2021-7-15
 * 作者：沈朗
 * 用户创建的关卡
 */
import QtQuick 2.0
import Felgo 3.0

Flickable {
    id: levelSelectionList

    width: grid.width
    height: (grid.height < parent.height) ? grid.height : parent.height
    contentWidth: grid.width
    contentHeight: grid.height
    flickableDirection: Flickable.VerticalFlick

    signal levelSelected(variant levelData)
    signal changeLevel(variant levelData)

    property alias levelMetaDataArray: levelListRepeater.model
    property alias levelColumn: grid
    property Component levelItemDelegate: Component{    //levellist
        Rectangle{
            id:rc
            height: width/5*4
            radius: 5
            width: levelSelectionList.width
            Rectangle{
                radius: rc.radius
                height: 20
                width: 20
                anchors.right: parent.right
                Image{
                    anchors.fill: parent
                    source: "../../assets/ui/remove.png"
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        createScene.isDemo = false
                        levelEditor.loadSingleLevel(modelData)
                        levelEditor.removeCurrentLevel()
                    }
                }
            }
            Row{
                anchors.bottom: rc.bottom
                Rectangle{
                    border.color: "gray"
                    radius: rc.radius
                    height: width
                    width: rc.width/2
                    Image {
                        anchors.fill: parent
                        source: "../../assets/ui/begin3.png"
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked:{
                            createScene.isDemo = false
                            createScene.gameScene.focus=true
                            levelScene.visible=false
                            levelSelectionList.levelSelected(modelData)
                        }
                    }
                }
                Rectangle{
                    border.color: "gray"
                    radius: rc.radius
                    height: width
                    width: rc.width/2
                    Image {
                        anchors.fill: parent
                        source: "../../assets/ui/create.png"
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            createScene.gameScene.focus=true
                            levelScene.visible=false
                            levelSelectionList.changeLevel(modelData)
                        }
                    }
                }
            }
        }
    }


    Grid {
        id: grid
        spacing: 10

        Repeater {
            id: levelListRepeater

            delegate: levelItemDelegate

        }// end of Repeater
    }
}
