/*
  时间：2021-7-16
  作者：苏浪
  角色：玩家的操控对象，游戏主要活动的承担者
  */
import QtQuick 2.0
import Felgo 3.0
import "../common"

EntityBaseDraggable{
    //
    property alias recstate: rec.state
    property alias supermarry: superMarry
    property alias supermarryLeft: superMarryLeft
    property int rightIsOnPressed: 0
    property int leftIsOnPressed:0
    property int upIsOnpressed: 0
    //
    property int jumpNumber: 2//修改该变量来判断角色能否跳跃
    property int speed: 200//基础速度
    property int maxFallingSpeed: 600//最大下落速度
    property int lastx: 0
    property int lasty: 0
    property int time: 0
    property int myCoins:0
    property int killNumbers:0
    property bool isBig:false
    property bool isInvincible: false
    property alias player: player
    property var json:{"x":x,"y":y,"entityType":entityType}

    width: rec.width
    height: rec.height
    entityType: "player"
    id:player
    colliderComponent: collider
    gridSize: 64
    colliderSize: 1
    opacity: isInvincible ? 0.5 : 1
    selectionMouseArea.anchors.fill: rec
    scale: isBig ? 1 : 0.6
    Behavior on scale { NumberAnimation { duration: 500 } }
    transformOrigin: Item.Bottom
    //自定义角色实体形状
    PolygonCollider{
        id:collider
        vertices: isBig ?
        // big collider
        [
          Qt.point(15, 24),
          Qt.point(25, 14),
          Qt.point(40, 14),
          Qt.point(47, 24),
          Qt.point(49, 62.8),
          Qt.point(44, 63),
          Qt.point(19, 63),
          Qt.point(14, 62.8)
        ] :
        // small collider
        [
          Qt.point(21, 39),
          Qt.point(28, 34),
          Qt.point(39, 34),
          Qt.point(43, 39),
          Qt.point(43, 62.85),
          Qt.point(40, 63),
          Qt.point(23, 63),
          Qt.point(20, 62.85)
        ]
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        fixedRotation: true
        sleepingAllowed: false
        categories: Box.Category3
        //Category1砖块：Category2：平台，Category5：敌人，Category6:道具，Category7:障碍,Category10:游戏边界
        //判断能与那些实体相碰撞
        collidesWith:Box.Category1|Box.Category5|Box.Category6|Box.Category7|Box.Category10
        friction: 0
        bodyType: createScene.gameScene.camera.state === "game"? Body.Dynamic: Body.Static
        fixture.onBeginContact: {
            var otherEntity = other.getBody().target
            ///////////////////////////////////
            if(otherEntity.entityType==="enemyJumper"||otherEntity.entityType==="trap"||otherEntity.entityType==="enemyWalker"||otherEntity.entityType==="trapBall"){
                if(!parent.isInvincible){
                    if(parent.isBig){
                        parent.isBig=false
                        beInvincible(1000)
                    }else{
                        //
                        defaultAudio.play()
                        //
                        createScene.gameScene.restart()
                        restart()
                    }
                }
            }else if(otherEntity.entityType==="coin"){
                //
                jianqianAudio.play()
                //
                otherEntity.die()
                myCoins++
            }else if(otherEntity.entityType==="mushroom"){
                //
                jianmoguAudio.play()
                //
                otherEntity.die()
                parent.isBig=true
            }else if(otherEntity.entityType==="star"){
                //
                jianmoguAudio.play()
                otherEntity.die()
                //
                beInvincible(4000)
            }else if(otherEntity.entityType==="wall"){
                //
                defaultAudio.play()
                //
                createScene.gameScene.restart()
                restart()
            }else if(otherEntity.entityType==="finish"){
                burstSignal()
                dialogTanChu.restart()
            }
        }


        onLinearVelocityChanged: {
            if(linearVelocity.y>maxFallingSpeed)
                linearVelocity.y=maxFallingSpeed
        }
    }

    //
    Timer{
        id:dialogTanChu
        interval: 2000
        repeat: false
        running: false
        onTriggered: {
            if(createScene.isDemo)
                createScene.demoDialog.visible = true
        }
    }

    signal burstSignal()
    Burst{
        id:myburst
//        anchors.fill: parent
    }
    onBurstSignal:{
        myburst.burstEmitter.burst(30,parent.width/2,parent.height+150)
        myburst.burstTimer.restart()
    }
    //

    BoxCollider{
        id:collider2
        width: 32*parent.scale
        height: 10*parent.scale
        bodyType: Body.Static
        collisionTestingOnlyMode: true
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
        categories: Box.Category4
        collidesWith:Box.Category1|Box.Category2|Box.Category5
        //通过不同的接触状态来判断玩家能否跳上平台
        fixture.onBeginContact: {
            var otherEntity = other.getBody().target
            if(otherEntity.entityType==="enemyWalker"||otherEntity.entityType==="enemyJumper"){
                //消灭敌人并播放音频
                caiguaiAudio.play()
                otherEntity.die()
                killNumbers++
                collider.linearVelocity.y=-parent.speed
                parent.jumpNumber=1
            }else if(otherEntity.entityType==="brick"||otherEntity.entityType==="grass"){
                parent.jumpNumber=2
            }else if(otherEntity.entityType==="plantform"){
                parent.jumpNumber=2
                collider.collidesWith=Box.Category1|Box.Category2|Box.Category5|Box.Category6
            }
        }
        fixture.onEndContact: {
            var otherEntity = other.getBody().target
            if(otherEntity.entityType==="plantform"){
                collider.collidesWith=Box.Category1|Box.Category5|Box.Category6
            }
        }
        fixture.onContactChanged:  {
            var otherEntity = other.getBody().target
            if(otherEntity.entityType==="plantform"){
                collider.collidesWith=Box.Category1|Box.Category2|Box.Category5|Box.Category6
            }
        }

    }
    BoxCollider {
      id: editorCollider

      anchors.fill: parent

      collisionTestingOnlyMode: true

      // Category16: misc
      categories: Box.Category16
    }


// player's vioce
    SoundEffect{
        id:caiguaiAudio

        source: "../caiguai.wav"
    }

    SoundEffect{
        id:defaultAudio
        volume: 1
        source: "../default.wav"
    }

    SoundEffect{
        id:jianqianAudio
        source: "../jianqian.wav"
    }

    SoundEffect{
        id:jumpAudio
        volume: 0.4
        source: "../jump.wav"
    }

    SoundEffect{
        id:vectorAudio
        source: "../vector.wav"
    }

    SoundEffect{
        id:jianmoguAudio
        source: "../jianmogu.wav"
    }

    //player's Animation  //defferent state have different Animation(player)
    Item{
        id:rec

        width: superMarry.width
        height: superMarry.height

        AnimatedSprite{
            id:superMarry
            source: "../../assets/superMarryLeft.png"
            frameCount:12
            frameWidth: 64
            frameHeight: 64
            frameDuration: 50
            running: true
            opacity:0
            visible: opacity>0.4
            loops: AnimatedSprite.Infinite
            interpolate: false
        }

        Image {
            id:standMarry
            opacity:0
            visible: opacity>0.4
            width: parent.width
            height: parent.height
            source: "../../assets/stand.png"
        }

        Image {
            id: jumpMarry
            opacity:0
            visible: opacity>0.4
            width: parent.width
            height: parent.height
            source: "../../assets/stand.png"
        }

        AnimatedSprite{
            id:superMarryLeft
            opacity:0
            visible: opacity>0.4
            width: parent.width
            height: parent.height
            frameWidth: 64
            frameHeight: 64
            frameCount: 12
            frameDuration: 50
            source: "../../assets/css_sprites.png"
            running: true
            loops: AnimatedSprite.Infinite
            interpolate: false
        }


        state: "stand"

        states: [
            State {
                name: "stand"
                PropertyChanges {
                    target: standMarry//rec//playerBase
                    opacity:1
                }
            },
            State {
                name: "jump"
                PropertyChanges {
                    target: jumpMarry//rec//playerBase
                    opacity:1
                }
            },


            State {
                name: "runRight"
                PropertyChanges {
                    target: superMarry//rec//playerBase
                    opacity:1
                }
            },
            State {
                name: "runLeft"
                PropertyChanges {
                    target: superMarryLeft//rec//playerBase
                    opacity:1
                }
            }
        ]

    }


    Timer{
        id:invincibleTime
        repeat: false
        interval: time
        onTriggered: isInvincible=false
    }
    //通过场景中的鼠标控制器来判断移动方向并移动
    function move()
    {
        collider.linearVelocity.x=createScene.gameScene.controller.xAxis*speed
        collider.focus=Qt.point(createScene.gameScene.controller.xAxis*speed, 0)
    }
    //判断能否跳跃并跳跃
    function jump()
    {
        if(jumpNumber>0){
            if(isBig){
                collider.linearVelocity.y=-createScene.gameScene.controller.yAxis*(speed)
                jumpNumber--
                //
                jumpAudio.play()
                //
            }else{
                collider.linearVelocity.y=-createScene.gameScene.controller.yAxis*(speed-30)
                jumpNumber--
                //
                jumpAudio.play()
                //
            }
        }
    }
    //重新设置场景时恢复初始位置，将获得的金币数量和击杀敌人数量清除
    function restart(){
        x=lastx
        y=lasty
        myCoins=0
        killNumbers=0
    }
    //进入无敌状态
    function beInvincible(mytime){
        isInvincible=true
        time=mytime
        invincibleTime.restart()
    }
    //初始化时记录初始位置
    Component.onCompleted: {
        lastx=x
        lasty=y
    }
}
