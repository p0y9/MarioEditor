/*
  时间：2021-7-16
  作者：苏浪
  草方块:玩家和敌人能够在这上面行走，跳跃
  */
import QtQuick 2.0
import Felgo 3.0

//与砖块类似，只是判定条件和图片不同,以砖块为基类
Brick{
    id:entity
    property var json:{"x":x,"y":y,"entityType":entityType}
    entityType: "grass"
    colliderComponent: collider
    gridSize: 32
    colliderSize: 1
    selectionMouseArea.anchors.fill: img
    Image {
        id: img
        source: "../../assets/image/ground_grass"
        MouseArea{
            anchors.fill: parent
            visible: createScene.state ==="remove"
            onClicked: {
                entityManager.removeEntityById(entityId)
                createScene.arrs.push(json)
            }
        }
    }
    BoxCollider{
        id:collider
        anchors.fill: parent
        bodyType: Body.Static
        //Category2：平台，Category3：玩家，Category4玩家脚部，Category5,敌人
        //判断能与那些实体相碰撞
        categories: Box.Category1
        collidesWith: Box.Category2|Box.Category3|Box.Category4|Box.Category5
    }
}
