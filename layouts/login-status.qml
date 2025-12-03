import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.12

Rectangle {
    id: statusBackground
    color: "#aa000000"

    GaussianBlur {
        anchors.fill: parent
        source: window
        samples: 128
        radius: 60
        transparentBorder: false
        cached: true
    }

    Column {
        anchors.centerIn: parent
        spacing: 12
        Image {
            source: "../assets/testmask.png"
            width: 45
            height: 45
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            text: "status"
            color: "#ffffff"
            font.pixelSize: 16
        }
    }
}

// FastBlur {
//     anchors.fill: statusBackground
//     source: statusBackground
//     radius: 60
//     transparentBorder: false
//     z: -5
// }