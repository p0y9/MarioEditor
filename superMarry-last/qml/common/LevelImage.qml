import QtQuick 2.0
/* saved levels in levelScene*/
import QtQuick.Controls.Styles 1.0
import Felgo 3.0
import QtGraphicalEffects 1.0

    Item {
        //anchors.fill: parent
        property alias image: image
        Image {
            id: image
            anchors.fill: parent
            smooth: true
            visible:false
            //source: ""
            //antialiasing: true
        }
        Rectangle{
            id:mask
            width: parent.width
            height: parent.height
            radius: 15
            visible: false
        }
        OpacityMask{
            anchors.fill: parent
            source: image
            maskSource: mask
        }
    }






