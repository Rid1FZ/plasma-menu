/*
    SPDX-License-Identifier: GPL-2.0-or-later
*/

const defaultIconName = "start-here-kde-symbolic";

function iconOrDefault(formFactor, preferredIconName) {
    return (formFactor === PlasmaCore.Types.Vertical && preferredIconName === "")
        ? defaultIconName : preferredIconName;
}
