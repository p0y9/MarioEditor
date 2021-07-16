/*
 * 时间：2021-7-15
 * 作者：沈朗
 * 显示用户创建的关卡和创建新的关卡
 */
import QtQuick 2.0
import Felgo 3.0
import "../scene"
import "../common"

Scene{

    id:levelScene
    property alias myGameNetworkView: myGameNetworkView
    property var level:[]
    signal backToMenu()
    opacity:0
    visible: opacity>0
    anchors.fill: parent
    StyledButton{
       id:levelEditorToMenu_Button
       z:1
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

    GameNetworkView{
        id: myGameNetworkView

        z: 1000

        anchors.fill: parent.gameWindowAnchorItem

        // invisible by default
        visible: false

        onShowCalled: {
            myGameNetworkView.visible = true
        }

        onBackClicked: {
            myGameNetworkView.visible = false
        }
    }

    //BackgroundImage
    Rectangle{
        anchors.fill: parent
        Image {
            anchors.fill: parent
            source: "../../assets/gamebk2.jpeg"
        }
    }
        //top row
    Row{
        id:topRow
        width: parent.width/3
        height:levelButton.height
        x:parent.width/3
        y:width/20
        Rectangle{
            id:levelButton
            radius: 10
            width: parent.width/2-5
            height: width/3
            border.color: "gray"
            Text {
                anchors.centerIn: parent
                font.pixelSize: 30
                color: "blue"
                text: qsTr("Levels")
            }
            color: "white"
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    parent.color = "lightgray"
                    netButton.color ="white"
                    row1.visible = true
                    row2.visible = false
                }
            }
        }
        Rectangle{
            id:netButton
            anchors.right: topRow.right
            radius: 10
            width: levelButton.width
            height: width/3
            border.color: "gray"
            Text {
                anchors.centerIn: parent
                font.pixelSize: 30
                color: "blue"
                text: qsTr("Net")
            }
            color: "white"
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    parent.color = "lightgray"
                    levelButton.color = "white"
                    row2.visible = true
                    row1.visible = false
                }
            }
        }
    }

    Row{
        id:row1
        width: topRow.width
        height: topRow.height
        x:topRow.x+30
        y:topRow.y+topRow.height+5
        visible: false
        spacing: 20
        Rectangle{
            width: height
            height: levelButton.height
            radius: width
            border.color: "lightgray"
            ImageButton{
                anchors.fill: parent
                source: "../../assets/ui/add.png"
                onClicked: {
                    createScene.gameScene.focus=true
                    levelEditor.createNewLevel()
                    createScene.visible = true
                    createScene.state = "add"
                    levelScene.visible = false
                    var com =Qt.createComponent("../entity/Player.qml")
                    var n =com.createObject(createScene.gameScene.world)
                    n.x=0
                    n.y=608
                }
            }
        }

        Rectangle{
            radius: 10
            opacity: 0.8
            width: levelButton.width
            height: levelButton.height
            border.color: "gray"
            Text {
                anchors.centerIn: parent
                font.pixelSize: 30
                color: "blue"
                text: qsTr("My Levels")
            }
            color: "white"
            MouseArea{
                anchors.fill: parent
                onClicked: {        //levelEditor load
                    levelEditor.loadAllLevelsFromStorageLocation(levelEditor.authorGeneratedLevelsLocation)
                }
            }
        }
    }

    Row{
        id:row2
        width: topRow.width
        height: topRow.height
        x:topRow.x
        y:topRow.y+topRow.height+5
        visible: false
        spacing: 10
        Rectangle{
            radius: 10
            width: levelButton.width
            height: levelButton.height
            border.color: "gray"
            Text {
                anchors.centerIn: parent
                font.pixelSize: 30
                color: "blue"
                text: qsTr("net")
            }
            color: "white"
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    gameNetwork.showLeaderboard()
                }
            }
        }
    }
    Item {
        width: parent.width
        height: width/2
        x:parent.width/20
        y:row1.y+row1.height+10
        visible: row1.visible
        LevelList{
            width: parent.width/6
            height: width-50
            levelMetaDataArray:levels(levelEditor.authorGeneratedLevels)
            onLevelSelected: {
                createScene.visible =true
                levelEditor.loadSingleLevel(levelData)

                var com =Qt.createComponent("../entity/Player.qml")
                var n =com.createObject(createScene.gamescenceIt)
                n.x=32
                n.y=608
                if(entityManager.getEntityArrayByType("wall").length!=0)
                    entityManager.removeEntityById("walls")
                var com1 =Qt.createComponent("../entity/Wall.qml")
                var n1 =com1.createObject(createScene.gameScene.world)
                n1.x=-500
                n1.y=createScene.selectEntityArray().y+200
                n1.width=createScene.selectEntityArray().x+1000
                createScene.state = "game"
            }
            onChangeLevel: {
                createScene.visible = true
                levelEditor.loadSingleLevel(levelData)
                createScene.state = "drag"
                var com =Qt.createComponent("../entity/Player.qml")
                var n =com.createObject(createScene.gamescenceIt)
                n.x=32
                n.y=608
                if(entityManager.getEntityArrayByType("wall").length!=0)
                    entityManager.removeEntityById("walls")
                var com1 =Qt.createComponent("../entity/Wall.qml")
                var n1 =com1.createObject(createScene.gameScene.world)
                n1.x=-500
                n1.y=createScene.selectEntityArray().y+200
                n1.width=createScene.selectEntityArray().x+1000
            }
        }
    }

    function levels(a){
        level.length=0
        if(a.length>3){
            for(var i=3;i<a.length;i++)
                level.push(a[i])
            return level
        }
        return null
    }
}
