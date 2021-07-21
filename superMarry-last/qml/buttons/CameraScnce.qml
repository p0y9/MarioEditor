/*
 * 时间：2021-7-13
 * 作者：沈朗
 * 游戏世界,跟随player移动
 */

import QtQuick 2.0
import Felgo 3.0
import "../entity"
import "../common"

Scene {
    id:gameScene
    visible: createScene.visible
    focus: true
    Keys.forwardTo: controller          //keys forwardTo
    z:-1
    property alias controller: controller
    property alias world: world
    property alias camera:camera

    Item{       //the game world
        id:world
        focus: true
        PhysicsWorld{
            updatesPerSecondForPhysics: 60
            gravity.y:9.81
        }
    }

    TwoAxisController {
        id: controller
        enabled: true
        onInputActionPressed: {         //defferent state have different Animation(player)
            if(actionName=="up"){
                entityManager.getEntityArrayByType("player")[0].player.jump()
                if(entityManager.getEntityArrayByType("player")[0].player.rightIsOnPressed==1 && entityManager.getEntityArrayByType("player")[0].player.leftIsOnPressed!=1){
                    entityManager.getEntityArrayByType("player")[0].player.recstate="runRight"
                    entityManager.getEntityArrayByType("player")[0].player.upIsOnpressed++
                }else if(entityManager.getEntityArrayByType("player")[0].player.rightIsOnPressed!=1 && entityManager.getEntityArrayByType("player")[0].player.leftIsOnPressed==1){
                    entityManager.getEntityArrayByType("player")[0].player.recstate="runLeft"
                    entityManager.getEntityArrayByType("player")[0].player.upIsOnpressed++
                }else{
                    entityManager.getEntityArrayByType("player")[0].player.recstate="jump"
                    entityManager.getEntityArrayByType("player")[0].player.upIsOnpressed++
                }

            }
            if(actionName=="right"){
                if(entityManager.getEntityArrayByType("player")[0].player.upIsOnPressed==1){
                    entityManager.getEntityArrayByType("player")[0].player.supermarry.resume()
                    entityManager.getEntityArrayByType("player")[0].player.recstate="runRight"
                    entityManager.getEntityArrayByType("player")[0].player.rightIsOnPressed++
                }else{
                    entityManager.getEntityArrayByType("player")[0].player.recstate="runRight"
                    entityManager.getEntityArrayByType("player")[0].player.rightIsOnPressed++
                }
            }
            if(actionName=="left"){
                if(entityManager.getEntityArrayByType("player")[0].player.upIsOnPressed==1){
                    entityManager.getEntityArrayByType("player")[0].player.supermarryLeft.resume()
                    entityManager.getEntityArrayByType("player")[0].player.recstate="runLeft"
                    entityManager.getEntityArrayByType("player")[0].player.leftIsOnPresed++
                }else{
                    entityManager.getEntityArrayByType("player")[0].player.recstate="runLeft"
                    entityManager.getEntityArrayByType("player")[0].player.leftIsOnPressed++

                }
            }
        }
        onInputActionReleased: {
            if(actionName=="up"){
                entityManager.getEntityArrayByType("player")[0].player.supermarry.resume()
                entityManager.getEntityArrayByType("player")[0].player.supermarryLeft.resume()
                entityManager.getEntityArrayByType("player")[0].player.upIsOnpressed--
                if(entityManager.getEntityArrayByType("player")[0].player.leftIsOnPressed===1 && entityManager.getEntityArrayByType("player")[0].player.rightIsOnPressed!==1){
                    entityManager.getEntityArrayByType("player")[0].player.recstate="runLeft"
                }
                if(entityManager.getEntityArrayByType("player")[0].player.rightIsOnPressed===1 && entityManager.getEntityArrayByType("player")[0].player.leftIsOnPressed!==1){
                    entityManager.getEntityArrayByType("player")[0].player.recstate="runRight"
                }
                if(entityManager.getEntityArrayByType("player")[0].player.rightIsOnPressed===1 && entityManager.getEntityArrayByType("player")[0].player.leftIsOnPressed===1){
                    entityManager.getEntityArrayByType("player")[0].player.recstate="stand"
                }
            }
            if(actionName=="right"){
                entityManager.getEntityArrayByType("player")[0].player.rightIsOnPressed--
                if(entityManager.getEntityArrayByType("player")[0].player.upIsOnpressed===1 && entityManager.getEntityArrayByType("player")[0].player.leftIsOnPressed!==1){
                    entityManager.getEntityArrayByType("player")[0].player.recstate="jump"
                }
                if(entityManager.getEntityArrayByType("player")[0].player.upIsOnpressed===1 && entityManager.getEntityArrayByType("player")[0].player.leftIsOnPressed===1){

                }
                if(entityManager.getEntityArrayByType("player")[0].player.upIsOnpressed!==1 && entityManager.getEntityArrayByType("player")[0].player.leftIsOnPressed!==1){
                    entityManager.getEntityArrayByType("player")[0].player.recstate="stand"
                }
            }



            if(actionName=="left"){
                entityManager.getEntityArrayByType("player")[0].player.leftIsOnPressed--
                if(entityManager.getEntityArrayByType("player")[0].player.upIsOnpressedd===1 && entityManager.getEntityArrayByType("player")[0].player.rightIsOnPressed!==1){
                    entityManager.getEntityArrayByType("player")[0].player.recstate="jump"
                }
                if(entityManager.getEntityArrayByType("player")[0].player.upIsOnpressedd===1 && entityManager.getEntityArrayByType("player")[0].player.rightIsOnPressed===1){

                }
                if(entityManager.getEntityArrayByType("player")[0].player.upIsOnpressedd!==1 && entityManager.getEntityArrayByType("player")[0].player.rightIsOnPressed!==1){
                    entityManager.getEntityArrayByType("player")[0].player.recstate="stand"
                }
            }
        }
        onXAxisChanged: entityManager.getEntityArrayByType("player")[0].player.move()
    }

    Camera{         //camera
        id:camera
        gameWindowSize: Qt.point(createScene.gameWindowAnchorItem.width,createScene.gameWindowAnchorItem.height)
        entityContainer: world
        focusedObject: null
        mouseAreaEnabled: true
        focusOffset: Qt.point(0.2, 0.3)
        mouseArea.onClicked: {
            if(createScene.entityUrl.length ==0)
                return

            var nx =((mouseArea.mouseX-entityManager.getEntityArrayByType("player")[0].player.mapToItem(null,0,0).x +50)/50|0) *50
            var ny =((mouseArea.mouseY-entityManager.getEntityArrayByType("player")[0].player.mapToItem(null,0,0).y +600)/50|0) *50

            var com =Qt.createComponent(createScene.entityUrl)
            var n =com.createObject(world)
            n.x=nx
            n.y=ny
        }

        limitLeft: 0
        limitTop: 0

        Component.onCompleted: {
            camera.centerFreeCameraOn(50, 500)
        }
        states: [
            State {
                name: "game"       //you can begin the game
                PropertyChanges {
                    target: camera;
                    focusedObject:entityManager.getEntityArrayByType("player")[0].player
                }
            },
            State {
                name: "drag"        // you can drag the scene
                PropertyChanges { target: camera;focusedObject:null }
            },
            State {
                name: "change"      //you can change the entity
                PropertyChanges {
                    target: camera;
                    focusedObject:entityManager.getEntityArrayByType("player")[0].player
                }
            }
        ]
    }

    function restart()
    {
        var opponentsJ =entityManager.getEntityArrayByType("enemyJumper")
        for(var oppJ in opponentsJ){
            opponentsJ[oppJ].restart()
        }
        var opponentsW =entityManager.getEntityArrayByType("enemyWalker")
        for(var oppW in opponentsW){
            opponentsW[oppW].restart()
        }
        var mushrooms =entityManager.getEntityArrayByType("mushroom")
        for(var mush in mushrooms){
            mushrooms[mush].restart()
        }
        var stars =entityManager.getEntityArrayByType("star")
        for(var sta in stars){
            stars[sta].restart()
        }
        var coins =entityManager.getEntityArrayByType("coin")
        for(var coi in coins){
            coins[coi].restart()
        }
    }

}
