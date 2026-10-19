/*
 *  SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2

import org.kde.plasma.core as PlasmaCore
import org.kde.ksvg as KSvg
import org.kde.iconthemes as KIconThemes
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM
import org.kde.config as KConfig
import org.kde.plasma.plasmoid

import "../code/tools.js" as Tools

KCM.SimpleKCM {
    id: root

    property string cfg_icon: Plasmoid.configuration.icon
    
    property alias cfg_showAdvancedMode: showAdvancedMode.checked
    property alias cfg_aboutThisComputerSettings: aboutThisComputerSettings.text
    property alias cfg_systemPreferencesSettings: systemPreferencesSettings.text
    property alias cfg_terminalSettings: terminalSettings.text
    property alias cfg_sleepSettings: sleepSettings.text
    property alias cfg_restartSettings: restartSettings.text
    property alias cfg_shutDownSettings: shutDownSettings.text
    property alias cfg_lockScreenSettings: lockScreenSettings.text
    property alias cfg_logOutSettings: logOutSettings.text

    Kirigami.FormLayout {
        QQC2.Button {
            id: iconButton
            Kirigami.FormData.label: "Icon:"
            implicitWidth: previewFrame.width + Kirigami.Units.smallSpacing * 2
            implicitHeight: previewFrame.height + Kirigami.Units.smallSpacing * 2
            hoverEnabled: true

            Accessible.name: "Change Menu icon"
            Accessible.description: "Current icon is " + root.cfg_icon + ". Click to open menu to change the current icon or reset to the default icon."
            Accessible.role: Accessible.ButtonMenu

            QQC2.ToolTip.delay: Kirigami.Units.toolTipDelay
            QQC2.ToolTip.text: "Icon name is " + root.cfg_icon
            QQC2.ToolTip.visible: iconButton.hovered && root.cfg_icon.length > 0

            KIconThemes.IconDialog {
                id: iconDialog
                onIconNameChanged: (iconName) => {
                    root.cfg_icon = iconName || Tools.defaultIconName;
                }
            }

            onPressed: iconMenu.opened ? iconMenu.close() : iconMenu.open()

            KSvg.FrameSvgItem {
                id: previewFrame
                anchors.centerIn: parent
                imagePath: Plasmoid.formFactor === PlasmaCore.Types.Vertical || Plasmoid.formFactor === PlasmaCore.Types.Horizontal
                    ? "widgets/panel-background" : "widgets/background"
                width: Kirigami.Units.iconSizes.large + fixedMargins.left + fixedMargins.right
                height: Kirigami.Units.iconSizes.large + fixedMargins.top + fixedMargins.bottom

                Kirigami.Icon {
                    anchors.centerIn: parent
                    width: Kirigami.Units.iconSizes.large
                    height: Kirigami.Units.iconSizes.large
                    source: Tools.iconOrDefault(Plasmoid.formFactor, root.cfg_icon)
                }
            }

            QQC2.Menu {
                id: iconMenu
                y: parent.height

                QQC2.MenuItem {
                    text: "Choose…"
                    icon.name: "document-open-folder"
                    onClicked: iconDialog.open()
                }
                QQC2.MenuItem {
                    text: "Reset to default icon"
                    icon.name: "edit-clear"
                    enabled: root.cfg_icon !== Tools.defaultIconName
                    onClicked: root.cfg_icon = Tools.defaultIconName
                }
                QQC2.MenuItem {
                    text: "Remove icon"
                    icon.name: "delete"
                    enabled: root.cfg_icon !== "" && Plasmoid.formFactor !== PlasmaCore.Types.Vertical
                    onClicked: root.cfg_icon = ""
                }
            }
        }
        
        QQC2.CheckBox {
            id: showAdvancedMode
            Kirigami.FormData.label: "Advanced Settings:"
            text: "Show advanced mode"
            checked: false
        }

        Kirigami.ActionTextField {
            id: aboutThisComputerSettings
            Kirigami.FormData.label: "About This Computer :"
            placeholderText: "kinfocenter"
            enabled: showAdvancedMode.checked
            rightActions: QQC2.Action {
                icon.name: "edit-clear"
                enabled: aboutThisComputerSettings.text !== ""
                onTriggered: {
                    aboutThisComputerSettings.clear()
                    root.cfg_aboutThisComputerSettings = ""
                }
            }
        }

        Kirigami.ActionTextField {
            id: systemPreferencesSettings
            Kirigami.FormData.label: "System Preferences :"
            placeholderText: "systemsettings"
            enabled: showAdvancedMode.checked
            rightActions: QQC2.Action {
                icon.name: "edit-clear"
                enabled: systemPreferencesSettings.text !== ""
                onTriggered: {
                    systemPreferencesSettings.clear()
                    root.cfg_systemPreferencesSettings = ""
                }
            }
        }

        Kirigami.ActionTextField {
            id: terminalSettings
            Kirigami.FormData.label: "Terminal :"
            placeholderText: "xdg-terminal-exec"
            enabled: showAdvancedMode.checked
            rightActions: QQC2.Action {
                icon.name: "edit-clear"
                enabled: terminalSettings.text !== ""
                onTriggered: {
                    terminalSettings.clear()
                    root.cfg_terminalSettings = ""
                }
            }
        }

        Kirigami.ActionTextField {
            id: sleepSettings
            Kirigami.FormData.label: "Sleep :"
            placeholderText: "systemctl suspend"
            enabled: showAdvancedMode.checked
            rightActions: QQC2.Action {
                icon.name: "edit-clear"
                enabled: sleepSettings.text !== ""
                onTriggered: {
                    sleepSettings.clear()
                    root.cfg_sleepSettings = ""
                }
            }
        }

        Kirigami.ActionTextField {
            id: restartSettings
            Kirigami.FormData.label: "Restart :"
            placeholderText: "qdbus-qt6 org.kde.LogoutPrompt /LogoutPrompt promptReboot"
            enabled: showAdvancedMode.checked
            rightActions: QQC2.Action {
                icon.name: "edit-clear"
                enabled: restartSettings.text !== ""
                onTriggered: {
                    restartSettings.clear()
                    root.cfg_restartSettings = ""
                }
            }
        }

        Kirigami.ActionTextField {
            id: shutDownSettings
            Kirigami.FormData.label: "Shut Down :"
            placeholderText: "qdbus-qt6 org.kde.LogoutPrompt /LogoutPrompt promptShutDown"
            enabled: showAdvancedMode.checked
            rightActions: QQC2.Action {
                icon.name: "edit-clear"
                enabled: shutDownSettings.text !== ""
                onTriggered: {
                    shutDownSettings.clear()
                    root.cfg_shutDownSettings = ""
                }
            }
        }

        Kirigami.ActionTextField {
            id: lockScreenSettings
            Kirigami.FormData.label: "Lock Screen :"
            placeholderText: "qdbus-qt6 org.kde.screensaver /ScreenSaver Lock"
            enabled: showAdvancedMode.checked
            rightActions: QQC2.Action {
                icon.name: "edit-clear"
                enabled: lockScreenSettings.text !== ""
                onTriggered: {
                    lockScreenSettings.clear()
                    root.cfg_lockScreenSettings = ""
                }
            }
        }

        Kirigami.ActionTextField {
            id: logOutSettings
            Kirigami.FormData.label: "Log Out :"
            placeholderText: "qdbus-qt6 org.kde.LogoutPrompt /LogoutPrompt promptLogout"
            enabled: showAdvancedMode.checked
            rightActions: QQC2.Action {
                icon.name: "edit-clear"
                enabled: logOutSettings.text !== ""
                onTriggered: {
                    logOutSettings.clear()
                    root.cfg_logOutSettings = ""
                }
            }
        }
    }
}
