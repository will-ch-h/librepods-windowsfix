pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Window

// A Windows 11 "volume OSD"-style flyout that briefly appears at the bottom
// of the screen when the AirPods connect. Frameless, translucent, always on
// top, no taskbar entry, and it never steals focus.
Window {
    id: popup

    // Detach from the (often-hidden) main window; otherwise this transient
    // child won't display when the main window is closed to the tray.
    transientParent: null

    flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | Qt.Tool
           | Qt.WindowDoesNotAcceptFocus
    color: "transparent"
    visible: false
    opacity: 0

    // The window is a bit larger than the card so the drop shadow has room.
    readonly property int margin: 16
    width: 380
    height: 104

    // Bottom-centre on whichever screen the window lands on, sitting above the
    // taskbar like the real volume OSD.
    x: Screen.virtualX + Math.round((Screen.width - width) / 2)
    y: Screen.virtualY + Screen.height - height - 56

    SystemPalette { id: sys; colorGroup: SystemPalette.Active }

    Timer {
        id: hideTimer
        interval: 4000
        onTriggered: hideAnim.start()
    }

    NumberAnimation {
        id: showAnim
        target: popup
        property: "opacity"
        from: 0; to: 1
        duration: 180
        easing.type: Easing.OutCubic
    }
    NumberAnimation {
        id: hideAnim
        target: popup
        property: "opacity"
        to: 0
        duration: 220
        easing.type: Easing.InCubic
        onFinished: popup.visible = false
    }

    function popUp() {
        hideAnim.stop()
        popup.opacity = 0
        popup.visible = true
        popup.raise()
        showAnim.restart()
        hideTimer.restart()
    }

    // Slide-up: the card eases up into place as the window fades in.
    Item {
        anchors.fill: parent
        transform: Translate { y: (1 - popup.opacity) * 18 }

        Rectangle {
            id: card
            anchors.fill: parent
            anchors.margins: popup.margin
            radius: 18
            // Acrylic-ish: theme background with a touch of translucency.
            color: Qt.rgba(sys.window.r, sys.window.g, sys.window.b, 0.92)
            border.width: 1
            border.color: Qt.rgba(sys.windowText.r, sys.windowText.g, sys.windowText.b, 0.10)

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 20
                spacing: 14

                Image {
                    Layout.preferredWidth: 56
                    Layout.preferredHeight: 56
                    Layout.alignment: Qt.AlignVCenter
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/icons/assets/" + airPodsTrayApp.deviceInfo.podIcon
                    smooth: true
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 3

                    Text {
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                        text: airPodsTrayApp.deviceInfo.deviceName !== ""
                              ? airPodsTrayApp.deviceInfo.deviceName : "AirPods"
                        color: sys.windowText
                        font.pixelSize: 16
                        font.bold: true
                    }
                    Text {
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                        text: airPodsTrayApp.deviceInfo.batteryStatus !== ""
                              ? airPodsTrayApp.deviceInfo.batteryStatus : "Connected"
                        color: Qt.rgba(sys.windowText.r, sys.windowText.g, sys.windowText.b, 0.7)
                        font.pixelSize: 12
                    }
                }
            }
        }
    }
}
