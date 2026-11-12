import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

ColumnLayout {
	width: parent.width
	height: 170
	anchors.centerIn: parent

	Rectangle {
		width: 128
		height: 128
		radius: 64
		border.color: "#26ffffff"
		border.width: 1
		Layout.alignment: Qt.AlignHCenter
	}

	Text {
		text: "awesoming name... defenestration"
		color: "white"
		font.pixelSize: 23
		font.family: inter.name
		Layout.alignment: Qt.AlignHCenter
	}

	Item {
		width: 230
		height: 30
		Layout.alignment: Qt.AlignHCenter

		TextField {
			width: 190
			height: 30
			color: "#ffffffff"
			placeholderText: "Password"
			placeholderTextColor: "#40ffffff"
			font.variableAxes: ({ "wght": 300 }) 
			leftPadding: 18
			font.pixelSize: 12
			echoMode: TextInput.Password
			passwordCharacter: "✦"

			background: Rectangle {
				color: "transparent"
				// radius: 95
				// border.color: "#26ffffff"
				// border.width: 1

		        // gradient: Gradient {
		        //     GradientStop { position: 0.00; color: "#4D000000" }
		        //     GradientStop { position: 1.00; color: "#33000000" }
		        // }

		        Image {
		        	source: "../assets/passwordPrompt.png"
		        	anchors.fill: parent
		        }
			}
		}

		Button {
			width: 30
			height: 30
			anchors.right: parent.right

			background: Rectangle {
				color: "transparent"

				Image {
					source: "../assets/passwordConfirm.png"
					anchors.fill: parent
				}
			}
		}
	}
}