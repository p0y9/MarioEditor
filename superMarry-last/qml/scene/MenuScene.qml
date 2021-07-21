/*The main interface*/

import QtQuick 2.12
import Felgo 3.0
import QtMultimedia 5.0
import "../common"


SceneBase{

    property int sezhiOnlcickedTime: 0
    property int bkmusicOnclickedTime: 1

    id:menuScene
    signal levelsSelectCilcked()
    signal levelEditorClicked()
    z:6
    Rectangle{
        anchors.fill: parent
        Image {
            anchors.fill: parent
            id: menuBackImage
            //fillMode:
            source: "../../assets/menubg.jpeg"
        }
    }

    BackgroundMusic{
        id:menuBackGroundMusic

        source: "../1.mp3"
        autoPauseInBackground: true
        //autoPlay: false
        loops: Audio.Infinite
        volume: 0.5
    }

    Row{
        id:row
        spacing: 0
        anchors.top: parent.top
        anchors.right: sezhi.left
        opacity: 0
        MenuBotton{
        id:decrease
        enabled: opacity=1 ? true : false
            width: gameWindow.width/20
            height: width
            image.source: "../../assets/pic.51yuansu-4.jpeg"
            radius: 0
            onDianji:{
                if(menuBackGroundMusic.volume>0.1){
                    menuBackGroundMusic.volume-=0.1
                }
            }
        }

        MenuBotton{
        id:add
        enabled: opacity=1 ? true : false
            width: gameWindow.width/20
            height: width
            image.source: "../../assets/pic.51yuansu-3.jpeg"
            radius: 0
            onDianji:{
                if(menuBackGroundMusic.volume<1){
                    menuBackGroundMusic.volume+=0.1
                }
            }
        }

        MenuBotton{
            id:bkMusic
//        opacity: 0
            enabled: opacity=1 ? true : false
            width: gameWindow.width/20
            height: width
            image.source: "../../assets/music.png"
            radius: 0
            onDianji:{
                if(bkmusicOnclickedTime==0){
                    bkmusicOnclickedTime++
//                    menuBackGroundMusic.play()
                    menuBackGroundMusic.muted=true
                }else{
                    bkmusicOnclickedTime--
//                    menuBackGroundMusic.pause()
                    menuBackGroundMusic.muted=false
                }
            }
        }
    }

    MenuBotton{
        id:sezhi
        anchors.top: parent.top
        anchors.right: parent.right
        width: gameWindow.width/20
        height: width
        image.source: "../../assets/options.png"
        radius: 0
        onDianji: {
            if(sezhiOnlcickedTime==0){
                sezhiAnimation.start()
                sezhiOnlcickedTime++
            }else{
                sezhiBack.start()
                sezhiOnlcickedTime--
            }
        }
    }

    ParallelAnimation{
        id:sezhiAnimation

        NumberAnimation{
            target: row
            property: "x"
            from:gameWindow.width
            to:gameWindow.width-4*sezhi.width
            duration: 1000
            easing{type: Easing.InBounce}
        }

        NumberAnimation{
            target: row
            property: "opacity"
            to:1
            duration: 500
        }
    }

    ParallelAnimation{
        id:sezhiBack
        NumberAnimation{
            target: row
            property: "x"
            //from:gameWindow.width
            to:gameWindow.width
            duration: 1000
            easing{type: Easing.InBounce}
        }

        NumberAnimation{
            target: row
            property: "opacity"
            to:0
            duration: 500
        }
    }

    Row{
        id:logo
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 0
        Image {
            width: logo_2.height
            height: logo_2.height
            id: logo_1
            source: "../../assets/logo1.jpeg"
        }
        Image {
            width: gameWindow.width/3
            height: width/2
            id: logo_2
            source: "../../assets/logo2.jpeg"
        }
    }

    NumberAnimation{
        id:logoAnimation
        target: logo
        property: "y"
        from:0
        to:twoButtons.y
        duration: 3000
        loops: Animation.Infinite
        easing{type: Easing.CosineCurve}
    }

    Component.onCompleted: {
        logoAnimation.start()
        //superMario.running=true
        //numAnimation.start()
    }

    Column{
        id:twoButtons
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        spacing: levelsSelect.width/8

        MenuBotton {
          id: levelsSelect
          image.source: "../../assets/playButton.png"
          width: gameWindow.width/5
          height: width*4/18
          scale: hovered ? 1.1 : 1
          anchors.topMargin: 40
//          color: "#cce6ff"
          radius: height / 4
          borderColor: "transparent"

          onDianji: {
            levelsSelectCilcked()
          }
        }

        MenuBotton{
            id:selfEditLevels
            image.source: "../../assets/levelsButton.png"
            width: gameWindow.width/5
            height: width*4/18
            scale: hovered ? 1.1 : 1
            radius: height / 4
            borderColor: "transparent"
            onDianji: {
                levelEditorClicked()
            }
        }
    }
}
