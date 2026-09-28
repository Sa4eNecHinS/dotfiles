import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

ShellRoot {
    PanelWindow {
        id: osd

        // ─────────────────────────────────────
        // Behaviour
        // ─────────────────────────────────────

        property int workspaceCount: 7

        property int bottomOffset: 90
        property int showDuration: 800

        property int fadeInDuration: 180
        property int fadeOutDuration: 220
        property int slideDistance: 10

        property int currentWorkspace: 1

        // true while island should be displayed
        property bool shown: false

        // ─────────────────────────────────────
        // Geometry
        // ─────────────────────────────────────

        property int itemWidth: 26
        property int itemHeight: 28
        property int itemSpacing: 5

        property int horizontalPadding: 16
        property int verticalPadding: 8

        // ─────────────────────────────────────
        // Waybar-inspired colors
        // ─────────────────────────────────────

        property color islandColor:
            Qt.rgba(255 / 255, 255 / 255, 225 / 255, 0.1)

        property color textColor: "#eaddcf"
        property color accentColor: "#a7c080"

        property color activeTextColor: "#2d353b"

        // ─────────────────────────────────────

        visible: false

        anchors {
            bottom: true
        }

        margins {
            bottom: osd.bottomOffset
        }

        implicitWidth:
            workspaceRow.implicitWidth
            + osd.horizontalPadding * 2

        implicitHeight:
            workspaceRow.implicitHeight
            + osd.verticalPadding * 2

        color: "transparent"

        exclusionMode: ExclusionMode.Ignore
        focusable: false
        aboveWindows: true

        // ─────────────────────────────────────
        // Island
        // ─────────────────────────────────────

        Rectangle {
            id: island

            anchors.fill: parent

            color: osd.islandColor
            radius: 17

            // ─────────────────────────────────
            // Animation state
            // ─────────────────────────────────

            opacity: osd.shown ? 1 : 0

            transform: Translate {
                id: slide

                // hidden -> slightly below
                // shown  -> normal position
                y: osd.shown ? 0 : osd.slideDistance

                Behavior on y {
                    NumberAnimation {
                        duration: osd.shown
                            ? osd.fadeInDuration
                            : osd.fadeOutDuration

                        easing.type: osd.shown
                            ? Easing.OutCubic
                            : Easing.InCubic
                    }
                }
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: osd.shown
                        ? osd.fadeInDuration
                        : osd.fadeOutDuration

                    easing.type: osd.shown
                        ? Easing.OutCubic
                        : Easing.InCubic
                }
            }

            RowLayout {
                id: workspaceRow

                anchors.centerIn: parent
                spacing: osd.itemSpacing

                Repeater {
                    model: osd.workspaceCount

                    Rectangle {
                        required property int index

                        property int workspaceId: index + 1
                        property bool active:
                            workspaceId === osd.currentWorkspace

                        Layout.preferredWidth: osd.itemWidth
                        Layout.preferredHeight: osd.itemHeight

                        radius: height 

                        color: active
                            ? osd.accentColor
                            : "transparent"

                        Text {
                            anchors.centerIn: parent

                            text: parent.workspaceId

                            color: parent.active
                                ? osd.activeTextColor
                                : osd.textColor

                            font.pixelSize: 18
                            font.family: "JetBrains Mono Nerd Font"
                            font.weight: Font.Thick
                        }
                    }
                }
            }
        }

        // ─────────────────────────────────────
        // Hide timer
        // ─────────────────────────────────────

        Timer {
            id: hideTimer

            interval: osd.showDuration
            repeat: false

            onTriggered: {
                osd.shown = false
                cleanupTimer.restart()
            }
        }

        // Wait until fade-out finishes before
        // destroying the visible surface.
        Timer {
            id: cleanupTimer

            interval: osd.fadeOutDuration
            repeat: false

            onTriggered: {
                osd.visible = false
            }
        }

        // ─────────────────────────────────────
        // Hyprland workspace events
        // ─────────────────────────────────────

        Connections {
            target: Hyprland

            function onRawEvent(event) {
                if (event.name !== "workspacev2")
                    return

                const args = event.parse(2)
                const workspaceId = Number(args[0])

                if (
                    workspaceId < 1 ||
                    workspaceId > osd.workspaceCount
                )
                    return

                osd.currentWorkspace = workspaceId

                // Important if another workspace switch
                // happens while fade-out is running.
                cleanupTimer.stop()

                osd.visible = true
                osd.shown = true

                hideTimer.restart()
            }
        }
    }
}
