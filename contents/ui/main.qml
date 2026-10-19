/*
 *  SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.extras as PlasmaExtras
import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root
    toolTipSubText: "Shortcuts for shutdown,reboot,logout, settings etc."
    hideOnWindowDeactivate: true
    Plasmoid.icon: plasmoid.configuration.icon
    property bool fullRepHasFocus: false
    
    Plasma5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        property var callbacks: ({})
        onNewData: {
            var stdout = data["stdout"]

            if (callbacks[sourceName] !== undefined) {
                callbacks[sourceName](stdout);
            }

            exited(sourceName, stdout)
            disconnectSource(sourceName) 
        }

        function exec(cmd, onNewDataCallback) {
            root.expanded = false
            if (onNewDataCallback !== undefined){
                callbacks[cmd] = onNewDataCallback
            }
            connectSource(cmd)
        }
        signal exited(string sourceName, string stdout)
    }

    PlasmaExtras.Highlight {
        id: delegateHighlight
        visible: false
    }

    onExpandedChanged : (expanded) => {
        if(expanded){
            root.fullRepHasFocus = true
        } else {
            if (delegateHighlight.parent) {
                delegateHighlight.parent.focus = false
                delegateHighlight.parent = null
            }
            root.fullRepHasFocus = false
        }
    }

    fullRepresentation: Item {
        id: fullRep
        
        readonly property double iwSize: Kirigami.Units.gridUnit * 12.6 
        readonly property double shSize: 1.1 
        
        readonly property string aboutThisComputerCMD: plasmoid.configuration.aboutThisComputerSettings
        readonly property string systemPreferencesCMD: plasmoid.configuration.systemPreferencesSettings
        readonly property string terminalCMD: plasmoid.configuration.terminalSettings
        readonly property string forceQuitCMD: plasmoid.configuration.forceQuitSettings
        readonly property string sleepCMD: plasmoid.configuration.sleepSettings
        readonly property string restartCMD: plasmoid.configuration.restartSettings
        readonly property string shutDownCMD: plasmoid.configuration.shutDownSettings
        readonly property string lockScreenCMD: plasmoid.configuration.lockScreenSettings
        readonly property string logOutCMD: plasmoid.configuration.logOutSettings
        
        Layout.preferredWidth: iwSize
        Layout.preferredHeight: aboutThisComputerItem.height * 12

        focus: root.fullRepHasFocus
        Keys.onPressed: (event) => {
            switch (event.key) {
                case Qt.Key_Up:
                    logOutItem.forceActiveFocus()
                    break;
                case Qt.Key_Down:
                    aboutThisComputerItem.forceActiveFocus()
                    break;

            }
        }

        ColumnLayout {
            id: columm
            anchors.fill: parent
            spacing: 2 
            
            ListDelegate {
                id: aboutThisComputerItem
                highlight: delegateHighlight
                text: "About This Computer"
                onClicked: {
                    executable.exec(aboutThisComputerCMD); 
                }
                activeFocusOnTab: true
                KeyNavigation.up: logOutItem
                KeyNavigation.down: systemPreferencesItem
            }

            MenuSeparator {
                id: s1
                padding: 0
                topPadding: 5
                bottomPadding: 5
                contentItem: Rectangle {
                    implicitWidth: iwSize
                    implicitHeight: shSize
                    color: "#1E000000"
                }
            }

            ListDelegate {
                id: systemPreferencesItem
                highlight: delegateHighlight
                width: parent
                text: "System Preferences..."
                onClicked: {
                    executable.exec(systemPreferencesCMD); 
                }
                activeFocusOnTab: true
                KeyNavigation.up: aboutThisComputerItem
                KeyNavigation.down: terminalItem
            }

            ListDelegate {
                id: terminalItem
                highlight: delegateHighlight
                text: "Terminal..."
                onClicked: {
                    executable.exec(terminalCMD); 
                }
                activeFocusOnTab: true
                KeyNavigation.up: systemPreferencesItem
                KeyNavigation.down: sleepItem
            }
            
            MenuSeparator {
                id: s3
                padding: 0
                topPadding: 5
                bottomPadding: 5
                contentItem: Rectangle {
                    implicitWidth: iwSize
                    implicitHeight: shSize
                    color: "#1E000000"
                }
            }

            ListDelegate {
                id: sleepItem
                highlight: delegateHighlight
                text: "Sleep"
                onClicked: {
                    executable.exec(sleepCMD); 
                }
                activeFocusOnTab: true
                KeyNavigation.up: terminalItem
                KeyNavigation.down: restartItem
            }

            ListDelegate {
                id: restartItem
                highlight: delegateHighlight
                text: "Restart..."
                onClicked: {
                    executable.exec(restartCMD); 
                }
                activeFocusOnTab: true
                KeyNavigation.up: sleepItem
                KeyNavigation.down: shutDownItem
            }

            ListDelegate {
                id: shutDownItem
                highlight: delegateHighlight
                text: "Shut Down..."
                onClicked: {
                    executable.exec(shutDownCMD); 
                }
                activeFocusOnTab: true
                KeyNavigation.up: restartItem
                KeyNavigation.down: lockScreenItem
            }

            MenuSeparator {
                id: s4
                padding: 0
                topPadding: 5
                bottomPadding: 5
                contentItem: Rectangle {
                    implicitWidth: iwSize
                    implicitHeight: shSize
                    color: "#1E000000"
                }
            }

            ListDelegate {
                id: lockScreenItem
                highlight: delegateHighlight
                text: "Lock Screen"
                onClicked: {
                    executable.exec(lockScreenCMD); 
                }
                activeFocusOnTab: true
                KeyNavigation.up: shutDownItem
                KeyNavigation.down: logOutItem
            }

            ListDelegate {
                id: logOutItem
                highlight: delegateHighlight
                text: "Log Out"
                onClicked: {
                    executable.exec(logOutCMD); 
                }
                activeFocusOnTab: true
                KeyNavigation.up: lockScreenItem
                KeyNavigation.down: aboutThisComputerItem
            }
        }
    }
}
