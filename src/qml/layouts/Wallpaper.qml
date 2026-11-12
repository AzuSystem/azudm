import QtQuick
import QtQuick.Effects
import Qt5Compat.GraphicalEffects

Item {
	anchors.fill: parent

	Image {
		source: "../assets/wallpaper.jpg"
		anchors.fill: parent    
		fillMode: Image.PreserveAspectCrop

		ShaderEffectSource {
			id: backgroundBlurSrc
			anchors.fill: parent
			sourceItem: parent
			sourceRect: Qt.rect(0, 0, width, height)
			live: true
			visible: false
		}
	}

	MultiEffect {
		source: backgroundBlurSrc
		anchors.fill: parent
		opacity: inPromptState ? 1 : 0

		blurEnabled: true
		blurMax: 48
		blur: 1
		autoPaddingEnabled: false

		Behavior on opacity {
	        NumberAnimation {
	            duration: 350
	            easing: Easing.InQuart
	        }
		}
	}

	Item {
		anchors.fill: parent

		Image {
			source: "../assets/fade.png"
			width: parent.width
			height: 205
			mirrorVertically: true
			opacity: inPromptState ? 1 : 0
			y: inPromptState ? 0 : -205

			Behavior on y {
		        NumberAnimation {
		            duration: 1200
		            easing: Easing.OutCubic
		        }
			}

			Behavior on opacity {
		        NumberAnimation {
		            duration: 2000
		            easing: Easing.OutQuart
		        }
			}
		}

		Image {
			source: "../assets/fade.png"
			width: parent.width
			height: 205
			y: inPromptState ? parent.height - height : parent.height

			Behavior on y {
		        NumberAnimation {
		            duration: 1200
		            easing: Easing.OutCubic
		        }
			}

			Behavior on opacity {
		        NumberAnimation {
		            duration: 2000
		            easing: Easing.OutQuart
		        }
			}
		}
	}

}