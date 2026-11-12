import QtQuick
import QtQuick.Effects

Item {
	anchors.fill: parent
    opacity: statusShow ? 1 : 0

   	Behavior on opacity {
   		NumberAnimation {
   			duration: 250
   			easing: Easing.InOutQuart
   		}
   	}

	ShaderEffectSource {
		id: statusBlurSrc
		anchors.fill: parent
		sourceItem: content
		sourceRect: Qt.rect(0, 0, width, height)
		live: true
		visible: false
	}

	MultiEffect {
		source: statusBlurSrc
		anchors.fill: parent

		blurEnabled: true
		blurMax: 48
		blur: 1
		autoPaddingEnabled: false
	}

	Rectangle { color: "#aa000000"; anchors.fill: parent }

    Column {
    	id: statusContent
        anchors.centerIn: parent
        spacing: 12
        scale: statusShow ? 1 : 0.9

	   	Behavior on scale {
	   		NumberAnimation {
	   			duration: 500
	   			easing: Easing.OutCirc
	   		}
	   	}

        Image {
            // source: "../assets/icons/wave.svg"
            source: "../assets/icons/" + statusIcon + ".svg"
            width: 45
            height: 45
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            text: statusText
            color: "#ffffff"
            font.pixelSize: 16
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }


	MultiEffect {
		source: statusContent
		anchors.fill: statusContent
		opacity: 0.35

		blurEnabled: true
		blurMax: 32
		blur: 1
	}
}