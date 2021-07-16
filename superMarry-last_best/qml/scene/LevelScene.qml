import QtQuick 2.0
import Felgo 3.0
import "../common"
import "../entity"
import "../buttons"

SceneBase{

    signal backToMenu()
    property var demo: []
    Rectangle{
        anchors.fill: parent
        Image {
            id: levelbg
            anchors.fill: parent
            source: "../../assets/selectLevelbg.jpeg"
        }
    }

    id:levelScene
    Item {
        anchors.centerIn: parent
            width: 500
            height: 200
            y:200
            Demolist{
                width: 80
                height: 50
                levelMetaDataArray: demos(levelEditor.authorGeneratedLevels)
                onLevelSelected: {
                    createScene.isDemo = true
                    createScene.visible =true
                    levelEditor.loadSingleLevel(levelData)
                    var com =Qt.createComponent("../entity/Player.qml")
                    var n =com.createObject(createScene.gamescenceIt)
                    n.x=32
                    n.y=608
                    createScene.state = "game"
                }
            }
        }

    Component.onCompleted: levelEditor.loadAllLevelsFromStorageLocation(levelEditor.authorGeneratedLevelsLocation)

    StyledButton{
       id:levelSelectToMenu_Button
        anchors.top: parent.top
        anchors.right: parent.right
        //color: "yellow"
        textColor: "black"
        text: "返回菜单"
        gradientTopColorLighterFactor: 1.15
        gradientBottomColor: "blue"
        gradientTopColor: "lightblue"
        radius: 4
        borderColor: "#888"
        borderWidth: activeFocus ? 2 : 1
        onClicked: backToMenu()
    }
    function demos(a){
        if(a.length>=3)
            for(var i=0;i<3;i++)
                demo[i]=a[i]
        return demo
    }
}

