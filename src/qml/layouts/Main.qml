import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Qt5Compat.GraphicalEffects
import QtQuick.Window
    
Window {
    id: window
    visible: true
    // visibility: Window.FullScreen
    width: screen.width
    height: screen.height
    title: "AzuDM"
    property date currentTime: new Date()
    property bool isTablet: false
    // property bool isEnterLoginState: false

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

    Wallpaper { blurOn: false }

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

                // if
            } else {
                timeReturnAnim.to = 0
                timeReturnAnim.start()
            }
            
        }
    }

}