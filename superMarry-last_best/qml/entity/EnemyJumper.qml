/*
  时间：2021-7-16
  作者：苏浪
  跳跃型敌人
  */
import QtQuick 2.0
import Felgo 3.0

EntityBaseDraggable{
    property alias enemycollider :collider
    property bool isliving: true
    property int lastx: 0
    property int lasty: 0
    entityType: "enemyJumper"
    id:entity
    property var json:{"x":x,"y":y,"entityType":entityType}
    colliderComponent: collider

    gridSize: 32
    colliderSize: 1
    selectionMouseArea.anchors.fill: img
    width: img.width
    height:img.height
    BoxCollider{
        id:collider
        anchors.fill: parent
        bodyType: createScene.gameScene.camera.state === "game"? Body.Dynamic: Body.Static
        categories: Box.Category5
        //Category1:砖块,Category2：平台，Category3：玩家，Category4玩家脚部
        //判断能与那些实体相碰撞
        collidesWith: Box.Category1|Box.Category2|Box.Category3|Box.Category4
    }
    Component.onCompleted: {
        lastx=x
        lasty=y
    }
    Timer{
        id:jump
        running: true
        repeat: true
        interval: 2000
        onTriggered: {
            enemycollider.linearVelocity.y=-200
        }
    }
    Image {
        id: img
        source: "../../assets/image/opponent_jumper.png"
        MouseArea{
            anchors.fill: parent
            visible: createScene.state ==="remove"
            onClicked: {
                entityManager.removeEntityById(entityId)
                createScene.arrs.push(json)
            }
        }
    }
    //在被角色踩踏后死亡
    function die()
    {
        jump.running=false
        visible=false
    }
    //重新设置场景时恢复位置，可见性和速度
    function restart(){
        jump.running=true
        visible=true
        x=lastx
        y=lasty
        enemycollider.linearVelocity.x=0
        enemycollider.linearVelocity.y=0
    }
}
