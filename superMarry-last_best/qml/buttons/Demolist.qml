/*
 * 时间：2021-7-15
 * 作者：沈朗
 * 演示关卡
 */
import QtQuick 2.0
import Felgo 3.0
import "../common"

Flickable {
    id: demoSelectionList

    width: grid.width
    height: (grid.height < parent.height) ? grid.height : parent.height
    contentWidth: grid.width
    contentHeight: grid.height
    flickableDirection: Flickable.VerticalFlick

    signal levelSelected(variant levelData)
    property alias levelMetaDataArray: levelListRepeater.model
    property alias levelColumn: grid
    property Component levelItemDelegate: Component{        //Demolist
        Rectangle{
            id:rc
            radius: 15
            width: gameWindow.width/10
            height: width/1.5
            LevelImage{
                id:levelImage
                anchors.fill: parent
                image.source:"../../assets/gamebk"+(index+1)+".jpeg"
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    createScene.gameScene.focus=true
                    createScene.isDemo = true
                    demoSelectionList.levelSelected(modelData)
                    if(entityManager.getEntityArrayByType("wall").length!=0)
                        entityManager.removeEntityById("walls")
                    var com =Qt.createComponent("../entity/Wall.qml")
                    var n =com.createObject(createScene.gameScene.world)
                    n.x=-500
                    n.y=createScene.selectEntityArray().y+200
                    n.width=createScene.selectEntityArray().x+1000
                }
            }
        }
    }
    Grid {
        id: grid
        spacing: 100
        rows: 1
        columns: 3
        Repeater {
            id: levelListRepeater
            delegate: levelItemDelegate

        }// end of Repeater
    }
}
