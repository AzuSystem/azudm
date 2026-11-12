import QtQuick
import QtQuick.Effects
import Qt5Compat.GraphicalEffects


    Item {
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        y: 107

        Text {
            id: sourceTime
            anchors.horizontalCenter: parent.horizontalCenter
            text: "12:00"
            font.family: instrumentsans.name
            font.variableAxes: ({ "wght": 500 }) // :(
            renderType: Text.NativeRendering // text was rounded for some reason...
            font.pixelSize: 98
            color: "#E6ffffff"
            style: Text.Outline
            styleColor: "#40000000"
            visible: false
        }

        MultiEffect {
            source: sourceTime
            anchors.fill: sourceTime
            opacity: 0.9

            shadowEnabled: true
            shadowColor: "#000000"
            shadowOpacity: 0.35
            blurMax: 32
            shadowBlur: 1
            shadowVerticalOffset: 8
            shadowHorizontalOffset: 0
        }

        Text {
            y: 100
            id: sourceDate
            anchors.horizontalCenter: parent.horizontalCenter
            text: "January 1, 2025"
            font.weight: Font.ExtraLight
            font.pixelSize: 50
            color: "#CCffffff"
            style: Text.Outline
            styleColor: "#40000000"
            visible: false
        }

        MultiEffect {
            source: sourceDate
            anchors.fill: sourceDate
            opacity: 0.8

            shadowEnabled: true
            shadowColor: "#000000"
            shadowOpacity: 0.35
            blurMax: 5
            shadowBlur: 1
            shadowVerticalOffset: 4
            shadowHorizontalOffset: 0
        }
    }