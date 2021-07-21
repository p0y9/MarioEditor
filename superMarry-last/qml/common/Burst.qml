/*  As player win,the fireworks will be triggerred*/

import QtQuick 2.7
import QtQuick.Particles 2.12
import QtQuick.Controls 2.12


Item {
    width: 640
    height: 480
    visible: true
    property var array:[]
//    property int n:4
//    property int i: 1
    property alias burstEmitter: burstEMitter
    property alias burstTimer: burstTimer
    property alias imageParticle1: imageParticle1

    signal ss()

//    Rectangle{
//        anchors.fill: parent
//        color: "black"


        ParticleSystem{
            id:particleSystem
            anchors.fill: parent

            ImageParticle{
                id:imageParticle1
                groups: ["group1"]
                source: "../../assets/3.png"
                colorVariation: 0.8
                entryEffect: ImageParticle.Scale

            }

            ImageParticle{
                groups: ["group2"]
                source: "../../assets/5.png"
                color: "#11111111"
                //colorVariation: 0.1
                entryEffect: ImageParticle.Scale
            }

            ImageParticle{
                id:imageparticle
                groups: ["group3"]
                source: "../../assets/3.png"
                alpha: 0
//                color: "red"
                colorVariation: 0.8
//                entryEffect: ImageParticle.Scale
                entryEffect: ImageParticle.Fade
                rotation: 60
                rotationVariation: 30
                rotationVelocity: 45
                rotationVelocityVariation: 15
            }

            Emitter{
                id:burstEMitter
                group: "group1"
//                anchors.horizontalCenter: parent.horizontalCenter
//                anchors.bottom: parent.bottom
                //anchors.verticalCenter: parent.verticalCenter
//                width: 20
//                height: 5
//                Rectangle{
//                    anchors.fill: parent
//                    color: "lightblue"
//                }

                enabled: false
                emitRate: 1
                lifeSpan: 1000
                lifeSpanVariation: 0
                size: 8;endSize: 10;sizeVariation: 2
                acceleration: PointDirection{y:100}
                velocity: AngleDirection{angle:270;angleVariation:45;
                                         magnitude:(gameWindow.height/600)*400;magnitudeVariation:10}

                onEmitParticles: {
                    array=particles

                }
            }


            TrailEmitter{
                id:trailEmitter
                group: "group2";follow: "group1"
                //emitRate:
                size: 1
                endSize: 0
                sizeVariation: 1
                emitRatePerParticle: 200
                lifeSpan: 500
                lifeSpanVariation: 300
                acceleration: PointDirection{y:-60}
                velocity: AngleDirection{angle: 270;magnitude: 70;
                                         angleVariation: 10;magnitudeVariation: 5}
            }

            Emitter{
                id:burstEmitter2
//                x:parent.width/2
//                y:parent.height/2
//                width: 0
//                height: 0
                group: "group3"
//                emitRate: 600
                lifeSpan: 1000
                lifeSpanVariation: 100
                size: 5;endSize: 5;sizeVariation: 4
                enabled: false
                velocity: CumulativeDirection{
                    AngleDirection{
                        angleVariation: 360;magnitude: 75;magnitudeVariation: 60;
                    }
                    PointDirection{y:20}
                }
                //acceleration:PointDirection{y:10}
            }

            Timer{
                id:burstTimer
                interval: 1000;running:false;repeat: false
                onTriggered: {
//                    burstEmitter2.burst(400,320,parent.height-1.6*parent.height/2)
//                    burstEmitter2.burst(300,320-100,parent.height-1.6*parent.height/2)
//                    burstEmitter2.burst(1800,320-50,parent.height-1.6*parent.height/2-100)
//                    burstEmitter2.burst(1300,320+50,parent.height-1.6*parent.height/2-100)
                    for(var i=0;i<array.length;i++){
                        burstEmitter2.burst(300,array[i].x,array[i].y);
                        if(i%3!=0){
//                          imageparticle.color=Qt.rgba(array[i].red,array[i].green,
//                                                      array[i].blue,array[i].alpha)
                        }
                    }

                }
            }

        }
//    }
}
