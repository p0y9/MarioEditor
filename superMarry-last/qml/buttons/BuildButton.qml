/*
 * 时间：2021-7-10
 * 作者：沈朗
 * 所有拖动创建实体的按钮的基类
 */
import QtQuick 2.0
import Felgo 3.0

//all BuildButton base
BuildEntityButton{
    width: parent.width/10
    height: parent.height/2
    property alias source: image.source
    Image {
        id: image
        anchors.fill: parent
    }
}
