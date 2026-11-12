import QtQuick
import QtQuick.Controls

Item {
	x: 28
	y: parent.height - 28 - height
	width: 230
	height: 30

	ComboBox {
		width: 190
		height: 30
		leftPadding: 12
		font.pixelSize: 11
		// color: "#ffffffff"
		font.variableAxes: ({ "wght": 300 }) 
	    model: ["First", "Second", "Third"]

	    background: Rectangle {
	    	color: "transparent"
	    	border.color: "#26ffffff"
	    	border.width: 1
	    	radius: 15

	    }
	}
}