import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.Pam

ShellRoot {
    id: root

    property bool sessionLocked: true
    property string keyboardLayout: ".."

    function shortLayout(layout) {
        const value = layout.toLowerCase()

        if (value.includes("russian"))
            return "RU"

        if (value.includes("english"))
            return "EN"

        return layout.slice(0, 2).toUpperCase()
    }

    PamContext {
        id: pam

        onPamMessage: {
            console.log(
                "PAM message:",
                message,
                "responseRequired:",
                responseRequired
            )

            if (responseRequired) {
                pam.respond(passwordInput.text)
            }
        }

        onError: error => {
            console.log("PAM ERROR:", error)
        }

        onCompleted: result => {
            console.log("PAM completed:", result)

            if (result === PamResult.Success) {
                console.log("PAM authentication successful")

                Quickshell.execDetached([
                    "hyprctl",
                    "keyword",
                    "misc:allow_session_lock_restore",
                    "1"
                ])

                Quickshell.execDetached([
                    "loginctl",
                    "unlock-session"
                ])

                root.sessionLocked = false
                Qt.quit()
            } else {
                console.log("PAM authentication failed:", result)

                passwordInput.text = ""
                passwordInput.forceActiveFocus()
            }
        }
    }

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (event.name === "activelayout") {
                const parts = event.parse(2)

                if (parts.length >= 2) {
                    root.keyboardLayout =
                        root.shortLayout(parts[1])
                }
            }
        }
    }

    // дальше WlSessionLock...
    // ─────────────────────────────────────────────
    // Session lock
    // ─────────────────────────────────────────────

    WlSessionLock {
        id: sessionLock
        locked: root.sessionLocked


        WlSessionLockSurface {
            color: "#d2c8a8"

            // ─────────────────────────────────────
            // Background
            // ─────────────────────────────────────

            Image {
                anchors.fill: parent

                source: "assets/background.jpg"

                fillMode: Image.PreserveAspectCrop
            }


            // Small paper tint.
            // We'll improve this later.

            Rectangle {
                anchors.fill: parent

                color: "#b8aa7d"
                opacity: 0.12
            }


            // ─────────────────────────────────────
            // CENTER
            // Visual story only.
            // ─────────────────────────────────────

            Item {
                id: visualArea

                anchors {
                    left: parent.left
                    right: authArea.left
                    top: parent.top
                    bottom: parent.bottom
                }


                Text {
                    id: clock

                    anchors.centerIn: parent

                    text: Qt.formatTime(new Date(), "HH:mm")

                    color: "#353125"

                    font.pixelSize: 86
                    font.weight: Font.Light
                }


                Text {
                    anchors {
                        horizontalCenter: clock.horizontalCenter
                        top: clock.bottom
                        topMargin: 8
                    }

                    text: Qt.formatDate(new Date(), "dd.MM.yyyy")

                    color: "#57503c"

                    font.pixelSize: 16
                    font.letterSpacing: 3
                }
            }


            // ─────────────────────────────────────
            // RIGHT
            // Interaction only.
            // ─────────────────────────────────────

            Item {
                id: authArea

                width: parent.width * 0.28

                anchors {
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                }


                Column {
                    width: parent.width * 0.70

                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        verticalCenter: parent.verticalCenter
                    }

                    spacing: 12


                    Text {
                        text: "AUTHORIZATION"

                        color: "#373328"

                        font.pixelSize: 14
                        font.bold: true
                        font.letterSpacing: 3
                    }


                    Rectangle {
                        width: parent.width
                        height: 1

                        color: "#514a38"
                    }

                    Text {
                        text: root.keyboardLayout

                        color: "#625b47"

                        font.pixelSize: 12
                        font.bold: true
                        font.letterSpacing: 2
                    }

                    Text {
                        text: "PASSWORD"

                        color: "#625b47"

                        font.pixelSize: 11
                        font.letterSpacing: 2
                    }


                    TextInput {
                        id: passwordInput

                        width: parent.width
                        height: 38

                        focus: true

                        echoMode: TextInput.Password
                        passwordCharacter: "■"

                        color: "#302d24"
                        selectionColor: "#756c50"

                        font.pixelSize: 18
                        font.letterSpacing: 3


                        Keys.onReturnPressed: {
                            if (text.length === 0)
                                return

                            pam.start()
                        }
                    }


                    Rectangle {
                        width: parent.width
                        height: 1

                        color: passwordInput.activeFocus
                            ? "#29261e"
                            : "#6d6650"
                    }


                    Text {
                        visible: pam.messageIsError

                        width: parent.width

                        text: pam.message

                        color: "#6d2923"

                        wrapMode: Text.WordWrap

                        font.pixelSize: 11
                    }


                    Item {
                        width: 1
                        height: 14
                    }


                    Text {
                        text: "ENTER // AUTHENTICATE"

                        color: "#625b47"

                        font.pixelSize: 10
                        font.letterSpacing: 2
                    }
                }
            }
        }
    }


    // ─────────────────────────────────────────────
    // Clock updater
    // ─────────────────────────────────────────────

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            clock.text = Qt.formatTime(new Date(), "HH:mm")
        }
    }
}
