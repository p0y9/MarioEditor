/*
  时间：2021-7-16
  作者：苏浪
  星星：玩家拾取后进入短暂的无敌状态
  */
import QtQuick 2.0
import Felgo 3.0

EntityBaseDraggable{
    width: img.width
    height:img.height
    entityType: "star"
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
        //Category1:砖块,Category2：平台，Category3：玩家，Category4:玩家脚部
        //判断能与那些实体相碰撞
        collidesWith: Box.Category1|Box.Category2|Box.Category3|Box.Category4
    }
    Image {
        id: img
        source: "../../assets/image/star.png"
        MouseArea{
            anchors.fill: parent
            visible: createScene.state ==="remove"
            onClicked: {
                entityManager.removeEntityById(entityId)
                createScene.arrs.push(json)
            }
        }
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
