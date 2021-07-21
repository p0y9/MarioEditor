/*
 * 时间：2021-7-15
 * 作者：沈朗
 * 所有图片按钮的基类
 */

import QtQuick 2.0

//all ImageButton base
Rectangle {
    property alias source:images.source
    signal clicked()
    radius: 8
    border.color: "lightgray"
    Image {
        id: images
        anchors.fill: parent
    }
    MouseArea{
        anchors.fill: parent
        onPressed: parent.opacity =0.5
        onReleased: parent.opacity =1
        onClicked: parent.clicked()
    }
}

