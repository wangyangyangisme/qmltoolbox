
import QtQuick 2.4

import QmlToolbox.Controls 1.0 as Controls


Item {
    id: item

    property var    pipelineInterface: null ///< Interface for communicating with the actual pipeline
    property string path:              ''   ///< Path to pipeline slot (e.g., 'pipeline.Stage1.in1')

    implicitWidth:  input.implicitWidth
    implicitHeight: input.implicitHeight

    Controls.TextField 
    {
        id: input

        anchors.fill: parent

        implicitWidth: 180

        onEditingFinished: pipelineInterface.setSlotValue(path, text);
    }

    function update() 
    {
        var slotInfo = pipelineInterface.getSlot(path);
        input.text = slotInfo.value;
    }
}
