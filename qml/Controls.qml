import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs
import Qt.labs.platform

import ru.hse.engagementEstimator 1.0

Window {
    id: controlsWindow
    width: Style.controlsWindowWidth
    height: Style.controlsWindowHeight
    visible: true
    title: qsTr("Screen capture controls")
    flags: Qt.Window | Qt.FramelessWindowHint | Qt.WA_TranslucentBackground | Qt.WindowStaysOnTopHint
    //flags: Qt.Window | Qt.FramelessWindowHint | Qt.WA_TranslucentBackground
    x: Style.controlWindowPositionX
    y: Style.controlWindowPositionY

    MessageDialog {
        id: errorDialog;
        // TODO: add positioning of the error message
        //x: Screen.width / 2
        //y: Screen.height / 2
        title: "Error!";

        onAccepted: {
            // TODO: Enable closing windows and openning main window
            //mainWindow.visible = true
            //screenAreaSelectorWindows.close()
            //controlsWindow.close();
            errorDialog.close();
        }
    }

    EngagementEstimator {
        id: engagementEstimator
        onError: function(msg) {
            console.log("EngagementEstimator Error!!! " + msg)
            errorDialog.text = msg
            errorDialog.open()
        }
        onResult: function(faces) {
            if (Config.debugMod) {
                debugInfoDrawer.recvResults(faces)
            } else {
                console.log("WARNING!!! Signal onResult was sent from EngagementEstimator in non debug mode!")
            }
        }
    }

    // The central area for moving the application window
    // Here you already need to use the position both along the X axis and the Y axis
    MouseArea {
        anchors.fill: parent
        // TODO: Fix cursorShape for buttons
        cursorShape:  Qt.SizeAllCursor

        onPressed: {
            previousX = mouseX
            previousY = mouseY
        }

        onMouseXChanged: {
            var dx = mouseX - previousX
            var new_x = Math.max(controlsWindow.x + dx, 0)
            // TODO: do the same thing for the right border
            controlsWindow.setX(new_x)
        }

        onMouseYChanged: {
            var dy = mouseY - previousY
            var new_y = Math.max(controlsWindow.y + dy, 0)
            controlsWindow.setY(new_y)
        }

        Button {
            id: startButton
            anchors.left: parent.left
            anchors.leftMargin: 7
            //height: Style.height
            width: Style.controlsWindowButtonWidth
            height: Style.elementHeight
            //background: StyleRectangle { anchors.fill: parent }
            text: qsTr("Start capturing")
            font.pixelSize: Style.fontSize
            onClicked: {
                if (engagementEstimator.running) {
                    engagementEstimator.stop()
                    screenAreaSelectorWindows.visible = true
                    screenAreaSelectorWindows.movable = true
                    screenAreaSelectorWindows.maximumHeight = screenAreaSelectorWindows.maxHeight
                    screenAreaSelectorWindows.maximumWidth = screenAreaSelectorWindows.maxWidth
                    screenAreaSelectorWindows.minimumHeight = screenAreaSelectorWindows.minHeight
                    screenAreaSelectorWindows.minimumWidth = screenAreaSelectorWindows.minWidth
                    text = qsTr("Start capturing")
                } else {
                    screenAreaSelectorWindows.movable = false
                    screenAreaSelectorWindows.maximumHeight = screenAreaSelectorWindows.height
                    screenAreaSelectorWindows.maximumWidth = screenAreaSelectorWindows.width
                    screenAreaSelectorWindows.minimumHeight = screenAreaSelectorWindows.height
                    screenAreaSelectorWindows.minimumWidth = screenAreaSelectorWindows.width
                    engagementEstimator.debugMod = Config.debugMod;
                    engagementEstimator.outputDirectory = outputPath.text;
                    engagementEstimator.setFrameCoordinates(screenAreaSelectorWindows.x, screenAreaSelectorWindows.y,
                                                             screenAreaSelectorWindows.width, screenAreaSelectorWindows.height);
                    if (!Config.debugMod) {
                        screenAreaSelectorWindows.visible = false
                    }
                    text = qsTr("Stop capturing")
                    engagementEstimator.start()
                }
            }
        }

        Button {
            id: closeButton
            anchors.right: parent.right
            anchors.rightMargin: 7
            width: Style.controlsWindowButtonWidth
            height: Style.elementHeight
            //height: Style.height
            //width: Style.widthMedium
            //background: StyleRectangle { anchors.fill: parent }
            //onClicked: root.capturesVisible = !root.capturesVisible
            text: qsTr("Close")
            font.pixelSize: Style.fontSize
            onClicked: {
                engagementEstimator.stop()
                mainWindow.visible = true
                screenAreaSelectorWindows.close()
                controlsWindow.close()
            }
        }
    }
}
