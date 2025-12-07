import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.12

ApplicationWindow {
    visible: true
    width: 1280
    height: 720
    title: "AzuDM Display Manager AZDM"
    font.family: "Inter"

    Item {
        id: root
        width: parent.width
        height: parent.height
        Image {
            id: background
            anchors.fill: parent
            source: "../assets/wallpaper.jpg"
            fillMode: Image.PreserveAspectCrop
        }

        Image {
            id: statusbarBackground
            source: "../assets/wallpaper.jpg"
            verticalAlignment: Image.AlignTop
            fillMode: Image.PreserveAspectCrop
            width: parent.width
            height: statusbar.height
            clip: true
        }

        GaussianBlur {
            source: statusbarBackground
            samples: 128
            radius: 60
            transparentBorder: false
            cached: true
            width: parent.width
            height: statusbar.height
        }

        Rectangle {
            id: statusbar
            color: "#60000000"
            width: parent.width
            height: 50

            Row {
                width: parent.width
                height: parent.height
                // leftPadding: 20
                // rightPadding: 20

                Text { // greeting based on system time
                    text: "Good Afternoon"
                    color: "#FFFFFF"
                    anchors.verticalCenter: parent.verticalCenter
                    x: 20
                    font.pixelSize: 16
                }

                Text { // distro name from os-release
                    text: "AzuOS"
                    color: "#FFFFFF"
                    font.pixelSize: 16
                    anchors.centerIn: parent
                }

                Row { 
                    anchors.verticalCenter: parent.verticalCenter
                    x: parent.width - childrenRect.width - 20
                    spacing: 8
                    Button {
                        width: 150
                        height: 30
                        anchors.verticalCenter: parent.verticalCenter
                        background: Rectangle {
                            color: "#00000000"
                            radius: 7
                            border.width: 1
                            border.color: "#50ffffff"
                        }
             
                        Text {
                            text: "Session1"
                            color: "#ffffff"
                            anchors.centerIn: parent
                            font.pixelSize: 13
                        }
                    }

                    Text { // time
                        text: "25:00" // -after midnight ( pjsk reference )
                        color: "#FFFFFF"
                        font.pixelSize: 16
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }   

        Rectangle {
            color: "#33FFFFFF"
            width: parent.width
            height: 1
            y: 50
        }

        Rectangle {
            width: 200
            // height: 100
            height: childrenRect.height

            color: "#aa000000"
            y: 50 + 15
            x: parent.width - width - 15
            radius: 12
            border.color: "#33ffffff"
            border.width: 1

            Component.onCompleted: {
                var sessions = backend.get_sessions(0)
                // console.log(sessions)
            }

            Row {
                width: parent.width
                // height: parent.height
                height: childrenRect.height
                // anchors.centerIn: parent

                SessionOption {
                    name: "Sessonn"
                    exec: "cmd"
                }
            }
        }

        Image {
            id: panelBackground
            source: "../assets/wallpaper.jpg"
            // verticalAlignment: Image.AlignCenter
            // horizontalAlignment: Image.AlignLeft
            sourceSize.width: background.width
            sourceSize.height: background.height
            sourceClipRect: Qt.rect(panel.x + 24, panel.y, panel.width - 24, panel.height)
            fillMode: Image.PreserveAspectCrop
            width: panel.width
            height: panel.height
            clip: true
            visible: false
        }

        GaussianBlur {
            source: panelBackground
            samples: 128
            radius: 60
            transparentBorder: false
            cached: true
            width: panel.width - 24
            height: panel.height
            x: 0
            y: (parent.height / 2 ) - 105
            // opacity: 0
        }

        Rectangle {
            id: panel
            color: "#AA000000"
            x: -24
            width: parent.width * ( 33/100 ) + 24
            height: 210
            y: (parent.height / 2 ) - 105
            radius: 24
            border.width: 1
            border.color: "#33FFFFFF"

            Column {
                width: parent.width - 24 - ( padding  )
                x: 24
                padding: 22
                spacing: 10
                Text { // greeting based on system time
                    text: "Login"
                    color: "#FFFFFF"
                    font.pixelSize: 24
                }

                TextField {
                    id: username
                    width: parent.width - parent.padding
                    height: 32
                    placeholderText: "Username"
                    padding: 5
                    leftPadding: 12
                    color: "#ffffff"
                    // anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 13
                    background: Rectangle {
                        color: "#00ffffff"
                        radius: 20
                        border.width: 1
                        border.color: "#50ffffff"
                        height: 32
                    }
                }
                TextField {
                    id: password
                    width: parent.width - parent.padding
                    height: 32
                    placeholderText: "Password"
                    padding: 5
                    leftPadding: 12
                    color: "#ffffff"
                    // anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 13
                    background: Rectangle {
                        color: "#00ffffff"
                        radius: 20
                        border.width: 1
                        border.color: "#50ffffff"
                        height: 32
                    }
                }
                Button {
                    width: parent.width - parent.padding
                    height: 32

                    background: Rectangle {
                        color: "#00ffffff"
                        border.color: "#50ffffff"
                        border.width: 1
                        radius: 24

                        

                        MouseArea {
                            width: parent.width
                            height: parent.height
                            hoverEnabled: true

                            onEntered: {
                                parent.color = "#10ffffff"
                                parent.scale = 1.01
                            }

                            onExited: {
                                parent.color = "#00ffffff"
                                parent.scale = 1
                            }

                            onClicked: {
                                status.item.svg = "loading"
                                status.item.authState = "Authenticating..."
                                status.opacity = 1
                                status.scale = 1.01
                                backend.auth_user(username.text, password.text);
                            }
                        }
                    }

                    Timer {
                        id: errorHideTimer
                        interval: 2000
                        repeat: false
                        onTriggered: {
                            status.opacity = 0
                        }
                    }

                    Connections {
                        target: backend
                        function onAuthFinished(success, error) {
                            if (success) {
                                errorHideTimer.stop()
                                status.item.svg = "wave";
                                status.item.authState = "Hello, " + username.text + "!";
                            } else {
                                status.item.svg = "x";
                                status.item.authState = "Incorrect Username or Password!";
                                errorHideTimer.start()
                            }
                        }
                    }

                    Text {
                        text: "Login"
                        color: "#ffffff"
                        font.pixelSize: 13
                        anchors.centerIn: parent
                    }
                }
            }
        }  

        // Item {
        //     Text {
        //         anchors.centerIn: parent
        //         text: "Hello World"
        //         font.pixelSize: 24
        //     }        
        // }
        Rectangle {
            anchors.centerIn: parent
            width: parent.width * ( 33/100 ) + 24
            height: parent.height * ( 85/100 )
            color: "#00000000"

            Column {
                anchors.centerIn: parent
                spacing: -10
                Text {
                    text: "25:00"
                    font.pixelSize: 100
                    font.weight: Font.Medium
                    color: "#ffffff"
                    anchors.horizontalCenter: parent.horizontalCenter
                }     

                Text {
                    text: "November 27, 2025" // arcaea v6.11 update drop, it was very peak
                    font.pixelSize: 50
                    font.weight: Font.Thin
                    color: "#ffffff"
                    anchors.horizontalCenter: parent.horizontalCenter
                }     
            }
        }  
    }

    Rectangle {
        anchors.fill: parent
        color: "#00ffffff"
        ShaderEffectSource {
            id: bgSrc
            anchors.fill: parent
            sourceItem: root
            live: true
            recursive: true
        }        
    }

    Loader {
        opacity: 0
        anchors.fill: parent
        id: status
        source: "login-status.qml"


        onLoaded: {
            if (item) {
                item.svg = "wave"
                item.authState = "state"
                opacity = 0
                scale = 1
            }
        }
    }  
}
