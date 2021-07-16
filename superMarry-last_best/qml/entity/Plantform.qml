/*
  时间：2021-7-16
  作者：苏浪
  平台：玩家能够从下方穿过平台并在上方站立
  */
import QtQuick 2.0
import Felgo 3.0

EntityBaseDraggable{
    width: img.width
    height: 8
    entityType: "plantform"
    id:entity
    property var json:{"x":x,"y":y,"entityType":entityType}
    colliderComponent: collider
    gridSize: 32
    colliderSize: 1
    selectionMouseArea.anchors.fill: img
    BoxCollider{
        id:collider
        anchors.fill: parent
        bodyType: Body.Static
        categories: Box.Category2
        //Category3：玩家，Category4玩家脚部，Category5,敌人
        //判断能与那些实体相碰撞
        collidesWith: Box.Category3|Box.Category4|Box.Category5
    }
    Image {
        id: img
        source: "../../assets/image/platform.png"
    }
}
