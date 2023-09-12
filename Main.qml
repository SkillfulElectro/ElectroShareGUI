import QtQuick
import QtQuick.Window
import QtQuick.Dialogs
import Qt.labs.platform
//import QtQuick.Dialogs 1.3

// handlers for Send mode and Recive mode
import Sender 1.0
import Reciver 1.0

Window {
    id : windo
    width: 640
    height: 480
    visible: true
    title: qsTr("ElectroShare")

    Text{
        z : 2
        text : "ElectroShare"
        font.bold: true
        font.pixelSize: 20
        color : "black"
        font.italic: true
        anchors{
            top : windo.top
            left : windo.left
        }

        MouseArea{
            anchors.fill: parent
            onClicked: {
                Qt.openUrlExternally("https://github.com/SkillfulElectro/ElectroShare.git")
            }
        }
    }

    Sender{
        id : send_mode

        onFailed_error: {
            console.log("failed")
            progress_text.text = "Failed"
        }

        onSent: {
            console.log("Sent")
            progress_text.text = "Sent"
        }

        onConnected: {
            progress_text.text = "Connected , Sending . . ."
        }

        onFile_notOpened: {
            console.log("file error")
            progress_text.text = "File error"
        }
    }
    Reciver{
        id : recive_mode

        onIpv: {
            file_IPv4_recive.text = "Your IPv4 : " + Ip
        }

        onFile_failed: {
            progress_text_recive.text = "creation failure"
        }

        onRecive_active: {
            progress_text_recive.text = "Waiting for Sender..."
            loader_recive_bar.color = "lightblue"
        }

        onReciving: {
            progress_text_recive.text = "Reciving . . ."
            loader_recive_bar.color = "green"
        }

        onRecive_failed_active: {
            progress_text_recive.text = "failed to start"
        }

        onRecived: {
            progress_text_recive.text = "Recived !"
        }

    }

    Rectangle{


        anchors.centerIn: parent
        id : root
        height : parent.height*2
        width : parent.width*2
        gradient: Gradient{
            GradientStop{
                position : 0
                color : "darkblue"
            }
            GradientStop{
                position: 0.75
                color : "lightblue"
            }
            GradientStop{
                position: 1
                color : "white"
            }
        }
        rotation: 25



        Row{
            id : buttons
            anchors.centerIn: root
            height: root.height/5
            spacing : 100
            rotation: -25

            Rectangle{
                id : sender
                height : parent.height
                width: height
                radius : height
                color : "darkblue"
                opacity: 0.75
                border.color: "lightblue"

                Behavior on opacity{
                    NumberAnimation{
                        duration: 300
                    }
                }

                Text {
                    text : "Send"
                    font.bold: true
                    font.pixelSize: 30
                    anchors.centerIn: parent
                    color : "white"
                }

                MouseArea{
                    id : sender_but
                    anchors.fill: parent
                    hoverEnabled: true
                    onContainsMouseChanged: {
                        if (containsMouse == true){
                            sender.opacity = 1
                        }else{
                            sender.opacity = 0.75
                        }
                    }
                    onClicked:{
                        input_send.opacity = 1
                        input_send.scale = 1
                    }
                }
            }
            Rectangle{
                id : reciver
                height : parent.height
                width : height
                radius : height
                color : "darkblue"
                border.color: "lightblue"

                Behavior on opacity{
                    NumberAnimation{
                        duration: 200
                    }
                }

                Text {
                    text : "Recive"
                    font.bold: true
                    font.pixelSize: 30
                    anchors.centerIn: parent
                    color : "white"
                }

                MouseArea{
                    id : reciver_but
                    anchors.fill: parent
                    hoverEnabled: true
                    onContainsMouseChanged: {
                        if (containsMouse == true){
                            reciver.opacity = 1
                        }else{
                            reciver.opacity = 0.75
                        }
                    }
                    onClicked:{
                        input_recive.opacity = 1
                        input_recive.scale = 1
                    }
                }
            }
        }

        Rectangle{
            rotation: -25
            id : input_send
            height : windo.height - 50
            width : windo.width - 50
            color : "black"
            opacity : 0
            scale : 0
            anchors.centerIn: parent
            radius : 10
            border.color: "white"


            Rectangle{
                color : "red"
                border.color : "white"
                anchors{
                    right : parent.right
                    top : parent.top
                }
                radius : 10
                height : 30
                width : 30

                Text{
                    text : "X"
                    anchors.centerIn: parent
                    font.bold: true
                    color : "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked:{
                        input_send.scale = 0 ; input_send.opacity = 0
                    }
                }
            }

            Behavior on opacity{
                NumberAnimation{
                    duration: 350
                }
            }
            Behavior on scale{
                NumberAnimation{
                    duration: 350
                }
            }

            DropArea{
                id : dropp
                anchors.fill: parent
                onDropped: {
                    console.log(drop.urls[0].toString()); // Print the url of the dropped item
                    send_path_field.text = drop.urls[0];
                }
            }

            Rectangle{
                z : 2
                id : progress
                anchors.centerIn: parent
                height : container_send.height
                width : container_send.width
                radius: 10
                color : "black"
                border.color: "white"
                opacity : 0
                scale : 0

                Behavior on opacity{
                    NumberAnimation{
                        duration: 350
                    }
                }
                Behavior on scale{
                    NumberAnimation{
                        duration: 350
                    }
                }

                Rectangle{
                    color : "red"
                    border.color: "white"
                    radius: 10
                    height : 30
                    width: height

                    Text{
                        text : "X"
                        anchors.centerIn: parent
                        font.bold: true
                        color : "white"
                    }

                    anchors{
                        top : parent.top
                        right : parent.right
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            progress.scale = 0
                            progress.opacity = 0
                            progress_text.text = "Loading . . ."
                        }
                    }
                }

                Column{
                    id : prog
                    anchors.centerIn: parent

                    Text{
                        id : progress_text
                        text : "Loading . . ."
                        color : "white"
                        font.bold: true
                        font.pixelSize: 20
                        anchors.horizontalCenter: parent.horizontalCenter
                        //anchors.verticalCenter: parent.verticalCenter
                    }
                    Rectangle{
                        anchors.horizontalCenter: parent.horizontalCenter
                        //anchors.verticalCenter: parent.verticalCenter
                        id : loader
                        visible: (progress_text.text == "Loading . . ." || progress_text.text == "Connected , Sending . . .")

                        border.color: "black"
                        color : "white"
                        height : progress_text.height + 5
                        width : 150
                        radius: 10
                        Rectangle{
                            height : loader.height
                            color : "darkblue"
                            radius: 10
                            NumberAnimation on width {
                                from : 0
                                to : loader.width
                                duration : 400
                                loops : Animation.Infinite
                            }
                        }
                    }
                }
            }

            Column{
                id : container_send
                anchors.centerIn: parent
                spacing : 5

                Text{
                    id :file_path
                    text : "File path :"
                    color : "white"
                    font.bold: true
                    font.pixelSize: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Rectangle{
                    height : file_path.height
                    width : 200
                    radius : 5
                    color : "white"
                    border.color: "black"
                    anchors.horizontalCenter: parent.horizontalCenter


                    TextInput{
                        id : send_path_field
                        anchors.fill: parent
                        font.pixelSize: 20
                        wrapMode: TextInput.NoWrap
                    }

                    FileDialog {
                        id: fileDialog
                        title: "Select your file to send !"
                        onAccepted: {
                            // Get the url of the selected file
                            send_path_field.text = fileDialog.currentFile.toString()
                        }
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: fileDialog.open(FileDialog.Open)
                    }
                }

                Text{
                    id : recive_ipv4
                    text : "IPv4 of Reciver :"
                    color : "white"
                    font.bold: true
                    font.pixelSize: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Rectangle{
                    height : file_path.height
                    width : 200
                    radius : 5
                    color : "white"
                    border.color: "black"
                    anchors.horizontalCenter: parent.horizontalCenter

                    TextInput{
                        id : send_ipv4_field
                        anchors.fill: parent
                        font.pixelSize: 20
                        wrapMode: TextInput.NoWrap
                    }



                    MouseArea{
                        anchors.fill: parent
                        onClicked: send_ipv4_field.focus = true
                    }
                }

                Rectangle{
                    height : file_path.height + 10
                    width : send_submit.width + 10
                    color : "white"
                    radius: 10
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text{
                        id : send_submit
                        anchors.centerIn: parent
                        text : "Submit"
                        font.bold: true
                        font.pixelSize: 20
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            send_mode.start(send_path_field.text , send_ipv4_field.text)
                            progress.opacity = 1
                            progress.scale = 1
                        }
                    }
                }
            }
        }

        Rectangle{
            rotation: -25
            id : input_recive
            height : windo.height - 50
            width : windo.width - 50
            color : "black"
            scale: 0
            opacity : 0
            anchors.centerIn: parent
            radius : 10
            border.color: "white"

            Rectangle{
                color : "red"
                anchors{
                    right : parent.right
                    top : parent.top
                }
                radius : 10
                height : 30
                width : 30
                border.color : "white"

                Text{
                    text : "X"
                    anchors.centerIn: parent
                    font.bold: true
                    color : "white"
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked:{
                        input_recive.scale = 0 ; input_recive.opacity = 0
                        file_IPv4_recive.text = "Your IPv4 : x.x.x.x"
                        recive_path_field.text = ""
                    }
                }
            }

            Behavior on opacity{
                NumberAnimation{
                    duration: 350
                }
            }
            Behavior on scale{
                NumberAnimation{
                    duration: 350
                }
            }

            Column{
                id : container_recive
                anchors.centerIn: parent
                Text {
                    id :file_IPv4_recive
                    text : "Your IPv4 : x.x.x.x"
                    color : "white"
                    font.bold: true
                    font.pixelSize: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Text{
                    id :file_path_recive
                    text : "save path :"
                    color : "white"
                    font.bold: true
                    font.pixelSize: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Rectangle{
                    height : file_path_recive.height
                    width : 200
                    radius : 5
                    color : "white"
                    border.color: "black"
                    anchors.horizontalCenter: parent.horizontalCenter


                    TextInput{
                        id : recive_path_field
                        anchors.fill: parent
                        font.pixelSize: 20
                        wrapMode: TextInput.NoWrap
                    }

                    FolderDialog {
                        id: fileDialog_recive
                        title: "Select your folder to save !"

                        //folder: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
                        onAccepted: {
                            // Get the url of the selected file
                            recive_path_field.text = fileDialog_recive.folder
                        }
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: fileDialog_recive.open()
                    }


                }
                Rectangle{
                    height : file_path_recive.height + 10
                    width : recive_submit.width + 10
                    color : "white"
                    radius: 10
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text{
                        id : recive_submit
                        anchors.centerIn: parent
                        text : "Submit"
                        font.bold: true
                        font.pixelSize: 20
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            recive_mode.start(recive_path_field.text)
                            progress_recive.opacity = 1
                            progress_recive.scale = 1
                        }
                    }
                }
            }
            Rectangle{
                z : 2
                id : progress_recive
                anchors.centerIn: parent
                height : container_recive.height
                width : container_recive.width
                radius: 10
                color : "black"
                border.color: "white"
                opacity : 0
                scale : 0

                Behavior on opacity{
                    NumberAnimation{
                        duration: 350
                    }
                }
                Behavior on scale{
                    NumberAnimation{
                        duration: 350
                    }
                }

                Rectangle{
                    color : "red"
                    border.color: "white"
                    radius: 10
                    height : 30
                    width: height

                    Text{
                        text : "X"
                        anchors.centerIn: parent
                        font.bold: true
                        color : "white"
                    }

                    anchors{
                        top : parent.top
                        right : parent.right
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            progress_recive.scale = 0
                            progress_recive.opacity = 0
                            progress_text_recive.text = "Loading . . ."
                            loader_recive_bar = "darkblue"
                        }
                    }
                }

                Column{
                    id : prog_recive
                    anchors.centerIn: parent
                    Text{
                        anchors.horizontalCenter: parent.horizontalCenter
                        text : file_IPv4_recive.text
                        font.pixelSize: 10
                        color : "white"
                    }

                    Text{
                        id : progress_text_recive
                        text : "Loading . . ."
                        color : "white"
                        font.bold: true
                        font.pixelSize: 20
                        anchors.horizontalCenter: parent.horizontalCenter
                        //anchors.verticalCenter: parent.verticalCenter
                    }
                    Rectangle{
                        anchors.horizontalCenter: parent.horizontalCenter
                        //anchors.verticalCenter: parent.verticalCenter
                        id : loader_recive
                        visible: ( progress_text_recive.text == "Reciving . . ."
                                  || progress_text_recive.text == "Loading . . ."
                                  || progress_text_recive.text == "Waiting for Sender...")

                        border.color: "black"
                        color : "white"
                        height : progress_text.height + 5
                        width : 150
                        radius: 10
                        Rectangle{
                            id : loader_recive_bar
                            height : loader.height
                            color : "darkblue"
                            radius: 10

                            Behavior on color{
                                ColorAnimation {
                                    duration : 200
                                }
                            }

                            NumberAnimation on width {
                                from : 0
                                to : loader.width
                                duration : 400
                                loops : Animation.Infinite
                            }
                        }
                    }
                }
            }

        }
    }
}
