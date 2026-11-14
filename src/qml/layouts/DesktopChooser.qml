import QtQuick
import QtQuick.Controls

Item {
	x: 28
	y: parent.height - 28 - height
	width: 230
	height: 30
	opacity: inPromptState ? 1 : 0
	scale: inPromptState ? 1 : 0.95

	Behavior on opacity {
		NumberAnimation {
			duration: 200
			easing: Easing.InOutQuart
		}
	}

	Behavior on scale {
		NumberAnimation {
			duration: 700
			easing: Easing.OutQuart
		}
	}

	property bool isDropdownOpen: false
	property string sessionName: sessionJSON[0].name
	property int sessionCount: sessionJSON.length;

	Button {
		width: 190
		height: 30

		background: Image {
			source: "../assets/passwordPrompt.png"

			Text {
				x: 12
				anchors.verticalCenter: parent.verticalCenter
				font.pixelSize: 11
				font.variableAxes: ({ "wght": 300 }) 
				text: sessionName
				color: "white"
			}
		}
	}

	Button {
		width: 30
		height: 30
		scale: down ? 0.9 : 1
		anchors.right: parent.right
		enabled: inPromptState

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
				source: "../assets/button.png"
				anchors.fill: parent
			}

			Image {
				id: dropdownArrow
				width: 10
				height: 5
				source: "../assets/icons/arrowup.svg"
				anchors.centerIn: parent
				rotation: 0

				Behavior on rotation {
					NumberAnimation {
						easing: Easing.InOutQuart
						duration: 450
					}
				}
			}
		}

		onPressed: {
			dropdownArrow.rotation -= 180
			isDropdownOpen = !isDropdownOpen
		}
	}

	Rectangle {
		width: 190
		height: 30 * sessionCount + 15
		y: isDropdownOpen ? -height - 5 : -height + 5
		radius: 15
		border.color: "#26ffffff"
		border.width: 1
		opacity: isDropdownOpen ? 1 : 0

		Behavior on opacity {
			NumberAnimation {
				duration: 200
				easing: Easing.OutCirc
			}
		}

		Behavior on y {
			NumberAnimation {
				duration: 450
				easing: Easing.OutCirc
			}
		}

		gradient: Gradient {
		    GradientStop { position: 0.00; color: "#4D000000" }
		    GradientStop { position: 1.00; color: "#33000000" }
		}

		Item {
			width: parent.width - 15
			height: parent.height - 15
			anchors.centerIn: parent

			ListView {
				anchors.fill: parent
				model: sessionJSON

				delegate: Button {
					width: parent.width
					height: 30
					enabled: isDropdownOpen


					onPressed: {
						sessionName = modelData.name
						isDropdownOpen = false
					}

					background: Rectangle {
						color: hovered ? "#15ffffff" : "transparent"
						radius: 5

						Text {
							text: modelData.name
							color: "white"
							font.pixelSize: 11
							x: 6
							anchors.verticalCenter: parent.verticalCenter
						}
					}
				}
			}
		}
	}
}