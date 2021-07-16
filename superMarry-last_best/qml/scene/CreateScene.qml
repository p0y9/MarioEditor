/*
 * 时间：2021-7-15
 * 作者：沈朗
 * 创建关卡的场景，包含相机场景
 */
import QtQuick 2.0
import Felgo 3.0
import "../buttons"
import "../"
import "../entity"

Scene{
    id:createScene
    anchors.fill: parent
    visible: false
    sceneAlignmentX: "left"
    sceneAlignmentY: "top"
    gridSize:64         //size created
    property alias gamescenceIt: gameScene.world    //the game world
    property alias gameScene:gameScene              //the gameScene
    property alias demoDialog:demoDialog            // the demoDialog
    property string entityUrl:""
    property bool isDemo :false     //isDemo
    property int times :0
    property var arrs:[]


    //beijing
    Rectangle{
        anchors.fill: parent
        z:-5
        Image {
            id:backImage
            source: "../../assets/gamebk1.jpeg"
        }
    }
    //Timer
    Item {
        anchors.left: parent.left
        width: parent.width
        height: 50
        Image {
            id:clock
            width: 50
            height: 50
            anchors.left: parent.left
            visible: createScene.state==="game"
            source: "../../assets/ui/clock.png"
        }
        Text {
            id:timesText
            width: 80
            height: 80
            color: "red"
            anchors.left: clock.right
            visible: createScene.state==="game"
            font.pixelSize: 30
            text: ": " +times
                  +"           : "+entityManager.getEntityArrayByType("player")[0].killNumbers
            +"               : "+entityManager.getEntityArrayByType("player")[0].myCoins
        }
        Image {
            id: kills
            width: 50
            height: 50
            x:120
            visible: createScene.state==="game"
            source: "../../assets/image/opponent_jumper.png"
        }
        Image {
            id: coins
            width: 50
            height: 50
            x:280
            visible: createScene.state==="game"
            source: "../../assets/image/coin.png"
        }
        Timer{
            id:time
            interval: 1000
            running: createScene.state =="game" ?true:false
            repeat: true
            onTriggered: times++
        }
    }

    //demo return
    ImageButton{
        visible: isDemo===false ? false : true
        width:parent.width/20
        height: width
        anchors.right: parent.right
        anchors.top: parent.top
        source: "../../assets/ui/home.png"
        onClicked: {
            isDemo = false
            createScene.visible=false
        }
    }
    //demoDialog:
    Rectangle{
        id:demoDialog
        anchors.fill: parent
        color: "lightgray"
        visible: false
        opacity: 0.8
        z:5
        Text {
            anchors.centerIn: parent
            color: "white"
            font.pixelSize: 50
            text: qsTr("You Win  !!!")
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                isDemo = false
                demoDialog.visible=false
                createScene.visible=false
            }
        }
    }

    //begin
    ImageButton{
        x:parent.width/2
        visible: isDemo==true ? false : true
        width: parent.width/15
        height: parent.height/10
        anchors.top: parent.top
        source: "../../assets/ui/begin1.png"
        onClicked: {
            createScene.gameScene.restart()
            if(entityManager.getEntityArrayByType("wall").length!=0)
                entityManager.removeEntityById("walls")
            var com =Qt.createComponent("../entity/Wall.qml")
            var n =com.createObject(gamescenceIt)
            n.x=-500
            n.y=selectEntityArray().y+200
            n.width=selectEntityArray().x+1000
            if(createScene.state=="game")
                createScene.state="drag"
            else(createScene.state="game")
        }
    }

    //save
    ImageButton{
        visible: isDemo===true ? false : true
        width: parent.width/20
        height: width
        anchors.right: shezhi.left
        source: "../../assets/ui/save.png"
        onClicked: {
            levelEditor.saveCurrentLevel()      //save levels
        }
    }

    //create return
    ImageButton{
        visible: isDemo===true ? false : true
        id:shezhi
        width:parent.width/20
        height: width
        anchors.right: parent.right
        anchors.top: parent.top
        source: "../../assets/ui/home.png"
        onClicked: {
            home.visible = true
        }
    }
    //create return
    Rectangle {
        id:home
        anchors.fill: parent
        color: "lightBlue"
        z:5
        opacity: 0.5
        visible: false
        MouseArea{
            anchors.fill: parent
        }
        Column{
            anchors.centerIn: parent
            spacing: 20
            SimpleButton{
                id:saveAndExit
                width:250
                text:"Save and Exit"        //saveAndExit the scene
                color: home.color
                onClicked: {
                    createScene.state="add"
                    levelEditor.saveCurrentLevel()
                    home.visible = false
                    createScene.visible = false
                    level.visible = true
                    changeImage.visible=false
                }
            }
            SimpleButton{
                width: saveAndExit.width
                text:"Exit"                 //exit the scene
                color: home.color
                onClicked: {
                    createScene.state="add"
                    home.visible = false
                    createScene.visible = false
                    level.visible = true
                    changeImage.visible=false
                }
            }
            SimpleButton{
                width: saveAndExit.width
                color: home.color
                text:"Cancel"
                onClicked: home.visible=false
            }
        }
    }

    //BackgroundImage selections
    Rectangle{
        id:changeImage
        visible: false
        width: parent.width/8
        height: parent.height-create.height
        anchors.top: parent.top
        color: "lightgray"
        Column{
            width: parent.width
            height:parent.height
            ImageButton{
                width: parent.width
                height: parent.height/3
                source: "../../assets/gamebk1.jpeg"
                onClicked: backImage.source = source
            }
            ImageButton{
                width: parent.width
                height: parent.height/3
                source: "../../assets/gamebk2.jpeg"
                onClicked: backImage.source = source
            }
            ImageButton{
                width: parent.width
                height: parent.height/3
                source: "../../assets/gamebk4.jpeg"
                onClicked: backImage.source = source
            }
        }
    }

    // changeImage Button
    ImageButton{
        id:changeImagebutton
        anchors.left:changeImage.visible===true?changeImage.right:parent.left
        y:(parent.height-create.height)/2
        width: height/3
        height: y/6
        visible: createScene.state!="game"
        source: "../../assets/ui/jiantou.png"
        onClicked: {
            changeImage.visible = !changeImage.visible
        }
    }

    CameraScnce{
        id:gameScene
    }

    //create bar
    Rectangle {
        id:create
        visible: createScene.state != "game"
        width: parent.width
        height: parent.height/9
        color: "green"
        anchors.bottom: parent.bottom

        Grid{
            id:grid1    //chuangjian zu
            anchors.left: parent.left
            width: parent.width/4
            height: parent.height
            property int group: 1
            ImageButton{
                id:lu
                width: height
                height: parent.height
                source: "../../assets/image/ground_grass.png"
                onClicked: {
                    grid1.group=1
                }
            }
            ImageButton{
                id:mounster
                width: height
                height: parent.height
                source: "../../assets/image/opponent_jumper.png"
                onClicked: {
                    grid1.group=2
                }
            }
            ImageButton{
                id:zhangai
                width: height
                height: parent.height
                source: "../../assets/image/coin.png"
                onClicked: {
                    grid1.group=3
                }
            }
        }
        //BuildButtons
        Rectangle{
            id:grid2
            clip: true
            color: parent.color
            anchors.left: grid1.right
            anchors.right: grid3.left
            height: parent.height
            Row{
                visible: grid1.group ===1
                anchors.fill: parent
                spacing: 2
                BuildButton{
                    width: height
                    height: grid2.height
                    source: "../../assets/image/ground_grass.png"
                    toCreateEntityTypeUrl: "../entity/Grass.qml"
                    onClicked:{
                        entityUrl = "../entity/Grass.qml"
                    }
                }
                BuildButton{
                    width: height
                    height: grid2.height
                    source: "../../assets/image/ground_dirt.png"
                    toCreateEntityTypeUrl: "../entity/Brick.qml"
                    onClicked:{
                        entityUrl = "../entity/Brick.qml"
                    }
                }
                BuildButton{
                    width: height
                    height: grid2.height
                    source: "../../assets/image/platform.png"
                    toCreateEntityTypeUrl: "../entity/Plantform.qml"
                    onClicked:{
                        entityUrl = "../entity/Plantform.qml"
                    }
                }
                BuildButton{
                    width: height
                    height: grid2.height
                    source: "../../assets/image/spikeball.png"
                    toCreateEntityTypeUrl: "../entity/TrapBall.qml"
                    onClicked:{
                        entityUrl = "../entity/TrapBall.qml"
                    }
                }
                BuildButton{
                    width: height
                    height: grid2.height
                    source: "../../assets/image/spikes.png"
                    toCreateEntityTypeUrl: "../entity/Trap.qml"
                    onClicked:{
                        entityUrl = "../entity/Trap.qml"
                    }
                }
                BuildButton{
                    width: height
                    height: grid2.height
                    source: "../../assets/image/finish.png"
                    toCreateEntityTypeUrl: "../entity/Finish.qml"
                    onClicked:{
                        entityUrl = "../entity/Finish.qml"
                    }
                }
            }
            Grid{
                visible: grid1.group ===2
                anchors.fill: parent
                spacing: 2
                BuildButton{
                    width: height
                    height: grid2.height
                    source: "../../assets/image/opponent_jumper.png"
                    toCreateEntityTypeUrl: "../entity/EnemyJumper.qml"
                    onClicked:{
                        entityUrl = "../entity/EnemyJumper.qml"
                    }
                }
                BuildButton{
                    width: height
                    height: grid2.height
                    source: "../../assets/image/opponent_walker.png"
                    toCreateEntityTypeUrl: "../entity/EnemyWalker.qml"
                    onClicked:{
                        entityUrl = "../entity/EnemyWalker.qml"
                    }
                }
            }
            Grid{
                visible: grid1.group ===3
                anchors.fill: parent
                spacing: 2
                BuildButton{
                    width: height
                    height: grid2.height
                    source: "../../assets/image/coin.png"
                    toCreateEntityTypeUrl: "../entity/Coin.qml"
                    onClicked:{
                        entityUrl = "../entity/Coin.qml"
                    }
                }
                BuildButton{
                    width: height
                    height: grid2.height
                    source: "../../assets/image/star.png"
                    toCreateEntityTypeUrl: "../entity/Star.qml"
                    onClicked:{
                        entityUrl = "../entity/Star.qml"
                    }
                }
                BuildButton{
                    width: height
                    height: grid2.height
                    source: "../../assets/image/mushroom.png"
                    toCreateEntityTypeUrl: "../entity/Mushroom.qml"
                    onClicked:{
                        createScene.state ="add"
                        entityUrl = "../entity/Mushroom.qml"
                    }
                }
            }
        }

        //tool bar
        Grid{
            id:grid3

            anchors.right: parent.right
            width: height*4
            height: parent.height
            ImageButton{        //last step....
                id:last
                width: parent.width/4
                height: width
                source: "../../assets/ui/undo_grey.png"
                onClicked: {
                    var a =entityManager.getLastAddedEntity()
                    arrs.push(a.json)
                    entityManager.removeLastAddedEntity()
                }
            }
            ImageButton{        //next step....
                id:next
                width: parent.width/4
                height: width
                source: "../../assets/ui/redo_grey.png"
                onClicked: {
                    if(arrs.length>0){                  //create the entity to return
                        var com =Qt.createComponent("../entity/"+change(arrs[arrs.length-1].entityType)+".qml")
                        var n =com.createObject(gameScene.world)
                        n.x=arrs[arrs.length-1].x
                        n.y=arrs[arrs.length-1].y

                        arrs.pop()
                    }
                    function change(str){
                        return str.charAt(0).toUpperCase()+str.slice(1)
                    }
                }
            }
            ImageButton{        //drag button
                width: parent.width/4
                height: width
                source: "../../assets/ui/hand.png"
                onClicked: {
                    createScene.state="drag"
                }
            }
            ImageButton{        //change button
                width: parent.width/4
                height: width
                source:"../../assets/ui/create.png"
                onClicked: {
                    createScene.state = "change"
                }
            }
        }
    }

    states: [
        State {
            name: "game"    //you can begin the game
            PropertyChanges {
                target: gameScene.camera; state:"game"
            }
        },
        State {
            name: "drag"    //you can drag the scene
            PropertyChanges {
                target: gameScene.camera; state:"drag"
            }
        },
        State {         //you can change the entity position
            name: "change"
            PropertyChanges {
                target: gameScene.camera; state:"change"
            }
        }
    ]
        //Find the maximum value of x and y
    function selectEntityArray(){
        var array=entityManager.getEntityArrayByType("player")
        for(var i = 1;i<entityManager.getEntityArrayByType("grass").length;i++){
            array.push(entityManager.getEntityArrayByType("grass")[i])
        }
        for(var i1 = 0;i1<entityManager.getEntityArrayByType("brick").length;i1++){
            array.push(entityManager.getEntityArrayByType("brick")[i1])
        }
        for(var i2 = 0;i2<entityManager.getEntityArrayByType("plantform").length;i2++){
            array.push(entityManager.getEntityArrayByType("plantform")[i2])
        }
        for(var i3 = 0;i3<entityManager.getEntityArrayByType("finish").length;i3++){
            array.push(entityManager.getEntityArrayByType("finish")[i3])
        }
        for(var i4 = 0;i4<entityManager.getEntityArrayByType("trap").length;i4++){
            array.push(entityManager.getEntityArrayByType("trap")[i4])
        }
        for(var i5 = 0;i5<entityManager.getEntityArrayByType("trapBall").length;i5++){
            array.push(entityManager.getEntityArrayByType("trapBall")[i5])
        }
        for(var i6 = 1;i6<entityManager.getEntityArrayByType("coin").length;i6++){
            array.push(entityManager.getEntityArrayByType("coin")[i6])
        }
        for(var i7 = 1;i7<entityManager.getEntityArrayByType("mushroom").length;i7++){
            array.push(entityManager.getEntityArrayByType("mushroom")[i7])
        }
        for(var i8 = 1;i8<entityManager.getEntityArrayByType("star").length;i8++){
            array.push(entityManager.getEntityArrayByType("star")[i8])
        }
        for(var i9 = 0;i9<entityManager.getEntityArrayByType("enemyJumper").length;i9++){
            array.push(entityManager.getEntityArrayByType("enemyJumper")[i9])
        }
        for(var i10 = 0;i<entityManager.getEntityArrayByType("enemyWalker").length;i10++){
            array.push(entityManager.getEntityArrayByType("enemyWalker")[i10])
        }
        return maxPoint(array)
    }

    function maxPoint(array){
        var xx=0,xy=0;
        for(var i=0;i<array.length;i++){
            if(array[i].x>xx)
                xx=array[i].x
            if(array[i].y>xy)
                xy=array[i].y
        }
        return Qt.point(xx,xy)
    }
}

