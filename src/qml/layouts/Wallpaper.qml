import QtQuick
import QtQuick.Effects
import Qt5Compat.GraphicalEffects

Item {
	property bool blurOn: false

	id: wallpaper
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

		blurEnabled: blurOn
		blurMax: 48
		blur: 1
		autoPaddingEnabled: false
	}

}