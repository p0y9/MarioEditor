/*As menuScene's button*/
import QtQuick 2.0
import QtQuick.Controls.Styles 1.0
import Felgo 3.0

GameButton {
  id: imageButton
  //height: parent.height

  signal dianji()

  property int borderWidth: 1
  property color borderColor: "black"
  property int radius: 3
  property alias image: image
  property alias hoverRectangle: hoverRectangle

  style: ButtonStyle {
    background: Rectangle {
      border.width: imageButton.borderWidth
      border.color: imageButton.borderColor
      radius: imageButton.radius
    }
  }

  onClicked: dianji()

  Rectangle {
    id: hoverRectangle
    anchors.fill: parent
    radius: imageButton.radius
    color: "lightblue"
    //opacity: hovered ? 0.8 : 0

  }

  MultiResolutionImage {
    id: image
    anchors.fill: parent
    anchors.margins: 1

    //fillMode: Image.PreserveAspectFit
    opacity: 1
  }


}
