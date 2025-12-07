import QtQuick 2.15
import QtQuick.Controls 2.15

                Button {
                    width: parent.width
                    height: 35

                    property string name: "Session"
                    property string exec: "exec"

                    background: Rectangle {
                        color: "#00ffffff"
                        radius: 10

                        MouseArea {
                            width: parent.width
                            height: parent.height
                            hoverEnabled: true

                            onEntered: {
                                parent.color = "#20ffffff"
                                parent.scale = 1.05
                            }

                            onExited: {
                                parent.color = "#00ffffff"
                                parent.scale = 1
                            }
                        }
                    }

                    Text {
                        // text: "Session"
                        text: name
                        color: "#ffffff"
                        font.pixelSize: 14
                        anchors.verticalCenter: parent.verticalCenter
                        x: 12
                    }
                }
