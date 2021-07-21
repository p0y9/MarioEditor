/*
  时间：2021-7-16
  作者：苏浪
  砖块，玩家和敌人能够在这上面行走，跳跃
  */
import QtQuick 2.0
import Felgo 3.0

EntityBaseDraggable{
    property var json:{"x":x,"y":y,"entityType":entityType}
    id:entity
    entityType: "brick"
    colliderComponent: collider
    gridSize: 32
    colliderSize: 1
    selectionMouseArea.anchors.fill: img
    width: img.width
    height:img.height

    BoxCollider{
        id:collider
        anchors.fill: parent
        bodyType: Body.Static
        categories: Box.Category1
        //Category2：平台，Category3：玩家，Category4玩家脚部，Category5,敌人
        //判断能与那些实体相碰撞
        collidesWith: Box.Category2|Box.Category3|Box.Category4|Box.Category5
    }
    Image {
        id: img
        source: "../../assets/image/ground_dirt.png"
    }
}
