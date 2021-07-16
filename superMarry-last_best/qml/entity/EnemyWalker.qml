/*
  时间：2021-7-16
  作者：苏浪
  左右移动型敌人
  */
import QtQuick 2.0
import Felgo 3.0

EntityBaseDraggable{
    property bool isliving: true
    property int lastx: 0
    property int lasty: 0
    property int where: 1
    property int speed: 100
    id:entity
    property var json:{"x":x,"y":y,"entityType":entityType}
    colliderComponent: collider
    gridSize: 32
    colliderSize: 1
    selectionMouseArea.anchors.fill: img
    entityType: "enemyWalker"
    width: img.width
    height: img.height

    //设置为自定义形状的实体
    PolygonCollider{
        id:collider
        vertices: [
          Qt.point(1, 15),
          Qt.point(31, 15),
          Qt.point(31, 30),
          Qt.point(26, 31),
          Qt.point(6, 31),
          Qt.point(1, 30)
        ]
        bodyType: createScene.gameScene.camera.state === "game"? Body.Dynamic: Body.Static
        categories: Box.Category5
        collidesWith: Box.Category1|Box.Category2|Box.Category3|Box.Category4
    }

    Timer{
        id:walk
        repeat: true
        running: true
        interval: 2000
        onTriggered: {
            collider.linearVelocity.x=speed*where
            where=-where
        }
    }

    Image {
        id: img
        source: "../../assets/image/opponent_walker.png"
    }
    Component.onCompleted: {
        lastx=x
        lasty=y
    }
    //重新设置场景时恢复位置，可见性和速度
    function restart(){
        walk.running=true
        visible=true
        x=lastx
        y=lasty
    }
    //在被角色踩踏后死亡
    function die()
    {
        walk.running=false
        visible=false
    }
}
