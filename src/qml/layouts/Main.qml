import QtQuick
import QtQuick.Window
    
Window {
    id: window
    visible: true
    visibility: Window.FullScreen
    width: screen.width
    height: screen.height
    title: "AzuDM"
    property date currentTime: new Date()
    property bool inPromptState: false

    property string statusIcon: "wave"
    property string statusText: "state"
    property bool statusShow: false

    Backend { id: backend }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: currentTime = new Date()
    }

    FontLoader { 
        id: instrumentsans
        source: "../assets/fonts/InstrumentSans-Variable.ttf" 
    }

    FontLoader { 
        id: inter
        source: "../assets/fonts/Inter-Regular.ttf" 
    }

    Item {
        anchors.fill: parent
        id: content

        Wallpaper { id: wallpaper }

        Item { 
            id: timedate
            width: window.width
            height: window.height

            TimeDate {}

            SpringAnimation {
                id: timeReturnAnim
                target: timedate
                property: "y"

                spring: 3
                damping: 0.25
                duration: 150
            }

            NumberAnimation {
                id: timeExitAnim
                target: timedate
                property: "y"

                duration: 500
                easing: Easing.InQuart

                onStarted: {
                    timedateMenuDrag.enabled = false
                }

                onFinished: {
                    inPromptState = true
                }
            }
        }

        DragHandler {
            id: timedateMenuDrag
            target: timedate
            xAxis.enabled: false
            yAxis.maximum: 0

            // onActiveTranslationChanged: {
            //     timedate.y = activeTranslation.y
            // }

            onActiveChanged: {
                console.log(timedate.y) // -278

                if ( timedate.y <= -100 ) {
                    timeExitAnim.to = -278
                    timeExitAnim.start()
                } else {
                    timeReturnAnim.to = 0
                    timeReturnAnim.start()
                }
                
            }
        }

        Prompt {}

        DesktopChooser {}
    }

    Status {}

}
