/*
  时间：2021-7-16
  作者：苏浪
  蘑菇：功能型道具，拾取后体型变大，跳跃能力增强，能够抵御一次伤害
  */
import QtQuick 2.0
import Felgo 3.0

EntityBaseDraggable{
    width: img.width
    height:img.height
    entityType: "mushroom"
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
        categories: Box.Category6
        collidesWith: Box.Category1|Box.Category2|Box.Category3|Box.Category4
    }

    Image {
        id: img
        source: "../../assets/image/mushroom.png"
    }
    //在被玩家拾取后消失
    function die()
    {
        visible=false
    }
    //重新设置可见性
    function restart(){
        visible=true
    }
}
