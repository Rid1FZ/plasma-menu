/*
 *  SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick
import QtQuick.Layouts

import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

Item {
    id: item

    signal clicked

    property Item highlight
    property alias text: label.text

    Layout.fillWidth: true
    height: row.height
    onFocusChanged: {
        if(focus){
            if (!highlight) {
                return
            }
            highlight.parent = item
            highlight.width = item.width
            highlight.height = item.height
            highlight.visible = true
            highlight.active = true
            highlight.hovered = true
        }
    }
    Keys.onPressed: (event) => {
        if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return || event.key === Qt.Key_Space) {
            event.accepted = true
            item.clicked()
        }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            item.clicked()
        }

        onContainsMouseChanged: {
            if (!highlight || !area.containsMouse) {
                return
            }
            item.focus = true
        }
    }

    RowLayout {
        id: row
        Item {
            id: emptySpace
            Layout.minimumWidth: 1 * Kirigami.Units.gridUnit
            Layout.maximumWidth: 1 * Kirigami.Units.gridUnit
        }

        Item {
            height: 24
            PlasmaComponents.Label {
                id: label
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
