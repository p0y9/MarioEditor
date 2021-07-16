/*
  时间：2021-7-16
  作者：苏浪
  游戏边界
  */
import QtQuick 2.0
import Felgo 3.0

EntityBase{
    entityType: "wall"
    width: 1
    height: 1
    entityId: "walls"
    BoxCollider{
        id:collider
        anchors.fill: parent
        bodyType: Body.Static
        categories: Box.Category10
        //只能与玩家接触
        collidesWith: Box.Category3 | Box.Category4
    }
}
