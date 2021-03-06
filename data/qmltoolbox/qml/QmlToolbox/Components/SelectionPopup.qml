

import QtQuick 2.0

import QmlToolbox.Base 1.0
import QmlToolbox.Controls 1.0


/**
*  SelectionPopup
*
*  Popup that displays a list of items the user can select
*/
Popup
{
    id: item

    signal selected(int index)

    property int   maxVisibleElements: 6
    property alias model:              list.model
    property alias listItem:           list

    width:  200
    height: calculateHeight()

    padding: 0

    Label
    {
        id: label
    }

    ListView
    {
        id: list

        anchors.fill: parent

        verticalLayoutDirection: ListView.BottomToTop
        boundsBehavior:          Flickable.StopAtBounds
        clip:                    true
        focus:                   true

        delegate: ItemDelegate
        {
            width:  parent.width
            height: item.rowHeight()

            topPadding:    0
            bottomPadding: 0

            text:        modelData
            highlighted: ListView.isCurrentItem

            onClicked:
            {
                list.select(index);
            }
        }

        Keys.onReturnPressed:
        {
            select(currentIndex);
            event.accepted = true;
        }

        Keys.onEscapePressed:
        {
            item.close();
        }

        function select(index)
        {
            item.selected(index);
            item.close();
        }
    }

    onOpened:
    {
        list.forceActiveFocus();
    }

    function rowHeight()
    {
        return label.font.pixelSize * 2.0;
    }

    function calculateHeight()
    {
        var count = Math.min(model.length, maxVisibleElements);
        return count * rowHeight();
    }
}
