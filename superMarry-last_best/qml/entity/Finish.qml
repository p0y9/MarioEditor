/*
  时间：2021-7-16
  作者：苏浪
  终点方块:玩家接触后结束游戏
  */
import QtQuick 2.0
import Felgo 3.0

//与砖块类似，只是判定条件和图片不同
EntityBaseDraggable{
    width: img.width
    height:img.height
    entityType: "finish"
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
        categories: Box.Category8
        //Category2：平台，Category3：玩家，Category4玩家脚部，Category5,敌人
        //判断能与那些实体相碰撞
        collidesWith: Box.Category2|Box.Category3|Box.Category4|Box.Category5
    }
    Image {
        id: img
        source: "../../assets/image/finish.png"
        MouseArea{
            anchors.fill: parent
            visible: createScene.state ==="remove"
            onClicked: {
                entityManager.removeEntityById(entityId)
                createScene.arrs.push(json)
            }
        }
    }
}
