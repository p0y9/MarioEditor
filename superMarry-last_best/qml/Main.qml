import Felgo 3.0
import QtQuick 2.0
import "scene"
import "common"
import "entity"
import "buttons"

GameWindow {
    id:gameWindow
    screenWidth: 960
    screenHeight: 480

    MenuScene{
        id:menuScene
        anchors.fill: parent
        onLevelEditorClicked:gameWindow.state="editor"
        onLevelsSelectCilcked: gameWindow.state="level"
    }

    LevelScene{
        id:levelScene
        anchors.fill: parent
        onBackToMenu: gameWindow.state="menu"

    }



    state: "menu"

    states: [
      State {
        name: "menu"
        PropertyChanges {target: menuScene; opacity: 1}
        PropertyChanges {target: gameWindow; activeScene: menuScene}
      },

      State {
        name: "level"
        PropertyChanges {target: levelScene; opacity: 1}
        PropertyChanges {target: gameWindow; activeScene: levelScene}
      },


        State {
            name: "editor"
            PropertyChanges {
                target: level;opacity:1
            }
            PropertyChanges {
                target: gameWindow;
                activeScene: level
            }
        }
    ]



    FelgoGameNetwork {
        id: gameNetwork

        // set id and secret
        gameId: 5
        secret: "abcdefg1234567890"
        // set gameNetworkView
        gameNetworkView: levelScene.myGameNetworkView
//        facebookItem: facebook
        onAchievementUnlockedAfterServerApproval: {

        }
        Component.onCompleted: {
            gameNetwork.incrementAchievement("5opens")
        }

        achievements: [
            Achievement {
                key: "5opens"
                name: "Game Opener"
                iconSource: "../assets/felgo-logo.png"
                target: 5
                points: 10
                description: "Open this game 5 times"
            },
            Achievement {
                key: "bossLevel2"
                name: "Obsessed Collector"
                iconSource: "../assets/felgo-logo.png"
                target: 1
                points: 5
                description: "Defeat boss enemy of level 2"
            },
            Achievement {
                key: "level3"
                name: "Third Level Master"
                iconSource: "../assets/felgo-logo.png"
                target: 3
                points: 15
                description: "Reach level 3"
            }
        ]
    }
    EntityManager {
        id: entityManager
        entityContainer: createScene.gamescenceIt
        dynamicCreationEntityList: [
            Qt.resolvedUrl("Brick.qml"),
            Qt.resolvedUrl("Coin.qml"),
            Qt.resolvedUrl("Grass.qml"),
            Qt.resolvedUrl("Player.qml"),
            Qt.resolvedUrl("Star.qml"),
            Qt.resolvedUrl("Plantform.qml"),
            Qt.resolvedUrl("Mushroom.qml"),
            Qt.resolvedUrl("Finish.qml")
        ]
    }
    //    PhysicsWorld{
    //        id:physicsWorld
    //    }

    LevelEditor {
        id:levelEditor
        applicationJSONLevelsDirectory: "jsonLevels/"
        levelLoaderItem: loader
        onUserBestLevelStatsChanged: {

            if(userBestLevelStats["best_quality"]) {
                var bestQuality = userBestLevelStats["best_quality"]["average_quality"]

                if(bestQuality >= 3)
                    gameNetwork.unlockAchievement("reachLevelQuality3")
                if(bestQuality >= 4)
                    gameNetwork.unlockAchievement("reachLevelQuality4")

            }
            if(userBestLevelStats["most_downloaded"]) {
                var mostDownloads = ["most_downloaded"]["times_downloaded"]

                if(mostDownloads >= 10)
                    gameNetwork.unlockAchievement("reachLevelDownloads10")
                if(mostDownloads >= 100)
                    gameNetwork.unlockAchievement("reachLevelDownloads100")
            }
        }
    }

    LevelLoader{
        id:loader
    }

    Level{
        id:level
        anchors.fill: parent
        onBackToMenu: gameWindow.state="menu"
    }

    CreateScene{
        id:createScene
        anchors.fill: parent
    }
}


