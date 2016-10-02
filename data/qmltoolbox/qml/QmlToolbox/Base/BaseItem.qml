
import QtQuick 2.0

import QmlToolbox.Base 1.0


/**
*  BaseItem
*
*  Base class for items
*
*  This class adds debug capabilities to items. If Ui.debugMode is enabled,
*  it will draw a colored rectangle around the space of the item to visualize
*  the item extends.
*/
Item
{
    id: item

    // Debug mode enabled? (displays borders around items)
    property bool debugMode: Ui.debugMode

    clip: true

    Rectangle
    {
        id: debugBorder

        anchors.fill: parent
        z:            100
        color:        'transparent'
        border.color: debugMode ? Ui.style.debugColor : 'transparent'
        border.width: debugMode ? 1 : 0
    }
}
