import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

ColumnLayout {
	width: parent.width
	height: 170
	anchors.centerIn: parent
	scale: inPromptState ? 1 : 0.8
	opacity: inPromptState ? 1 : 0

	Behavior on scale {
		NumberAnimation {
			easing: Easing.OutQuart
			duration: 1200
		}
	}

	Behavior on opacity {
		NumberAnimation {
			easing: Easing.OutSine
			duration: 800
		}
	}

	Item {
		width: 90
		height: 90
		Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

		Rectangle {
			id: sourcePfp
			width: 90
			height: 90
			radius: 45
			border.color: "#26ffffff"
			border.width: 1

			Image {
				id: pfpImage
				anchors.fill: parent
				source: ""
				visible: false
			}

			Item {
		        id: pfpMask
		        anchors.fill: parent
		        layer.enabled: true
		        visible: false

		        Rectangle {
		            anchors.fill: parent
		            radius: 45
		        }
		    }

		    // Apply the mask to the image
		    MultiEffect {
		        source: pfpImage
		        anchors.fill: sourcePfp
		        maskEnabled: true
		        maskSource: pfpMask
		    }
		}

		MultiEffect {
			source: sourcePfp
			anchors.fill: sourcePfp

			shadowEnabled: true
			shadowColor: "#000000"
			shadowOpacity: 0.30
			blurMax: 24
			shadowBlur: 1
			shadowVerticalOffset: 4
			shadowHorizontalOffset: 0
		}
	}

	Item {
		Layout.alignment: Qt.AlignHCenter
		// Layout.fillWidth: true
		// Layout.bottomMargin: -28
		Layout.topMargin: -56

		Text {
			anchors.horizontalCenter: parent.horizontalCenter
			id: sourceUsername
			text: "awesoming name... defenestration"
			color: "white"
			font.pixelSize: 23
			font.family: inter.name
			renderType: Text.CurveRendering
		}

		MultiEffect {
			source: sourceUsername
			anchors.fill: sourceUsername

			shadowEnabled: true
			shadowColor: "#000000"
			shadowOpacity: 0.25
			blurMax: 6
			shadowBlur: 1
			shadowVerticalOffset: 4
			shadowHorizontalOffset: 0
		}
	}

	Item {
		width: 230
		height: 30
		Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom

		TextField {
			id: password
			width: 190
			height: 30
			color: "#ffffffff"
			placeholderText: "Password"
			placeholderTextColor: "#40ffffff"
			font.variableAxes: ({ "wght": 300 }) 
			leftPadding: 12
			font.pixelSize: 11
			echoMode: TextInput.Password
			passwordCharacter: "✦"

			background: Rectangle {
				color: "transparent"
				// radius: 95
				// border.color: "#26ffffff"
				// border.width: 2

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
			scale: down ? 0.9 : 1
			anchors.right: parent.right

			Behavior on scale {
				NumberAnimation {
					easing: Easing.OutCirc
					duration: 150
				}
			}

			background: Rectangle {
				radius: 15
				color: parent.down ? "#10000000" : parent.hovered ? "#08ffffff" : "transparent"

				Image {
					source: "../assets/passwordConfirm.png"
					anchors.fill: parent
				}
			}

			onPressed: {
				statusIcon = "loading"
				statusText = "Authenticating..."
				statusShow = true

				backend.auth("hi", password.text)
			}
		}
	}
}