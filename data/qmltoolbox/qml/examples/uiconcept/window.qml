
import QtQuick 2.4
import QtQuick.Layouts 1.1

import Qt.labs.settings 1.0 as Labs

import QmlToolBox.Controls 1.0 as Controls
import QmlToolBox.Components 1.0 as Components
import QmlToolBox.PropertyEditor 1.0 as PropertyEditor

import com.cginternals.qmltoolbox 1.0

Controls.ApplicationWindow
{
    id: window

    visible: true

    x: settings.x
    y: settings.y
    width: settings.width
    height: settings.height

    signal toFullScreen()
    signal toNormalScreen()

    Controls.Shortcut 
    {
        sequence: "CTRL+F6"
        onActivated: leftPanelView.togglePanel()
    }

    Controls.Shortcut 
    {
        sequence: "CTRL+F7"
        onActivated: bottomPanelView.togglePanel()
    }

    Controls.Shortcut 
    { 
        sequence: "CTRL+F11"
        onActivated: togglePreviewMode();
    }

    Controls.Shortcut
    {
        sequence: "F11"
        onActivated: toggleFullScreenMode();
    }

    Controls.Shortcut
    {
        sequence: "ALT+RETURN"
        onActivated: toggleFullScreenMode();
    }

    function togglePreviewMode() 
    {
        stateWrapper.state = (stateWrapper.state == "normal") ? "preview" : "normal";
    }

    Item 
    {
        id: stateWrapper

        state: "normal"

        states: 
        [
            State 
            {
                name: "preview"

                StateChangeScript { script: leftPanelView.setPanelVisibility(false) }
                StateChangeScript { script: bottomPanelView.setPanelVisibility(false) }

                PropertyChanges 
                {
                    target: window
                    header: null
                }

                PropertyChanges 
                {
                    target: drawer
                    visible: false
                }
            },
            State 
            {
                name: "normal"

                StateChangeScript { script: leftPanelView.setPanelVisibility(true) }
                StateChangeScript { script: bottomPanelView.setPanelVisibility(true) }
            }
        ]
    }

    function toggleFullScreenMode()
    {
        fsStateWrapper.state = (fsStateWrapper.state == "normalScreen") ? "fullScreen" : "normalScreen";
    }

    Item 
    {
        id: fsStateWrapper

        state: "normalScreen"

        states: 
        [
            State 
            {
                name: "normalScreen"

                StateChangeScript { script: window.toNormalScreen() }
            },
            State 
            {
                name: "fullScreen"

                StateChangeScript { script: window.toFullScreen() }
            }
        ]
    }

    Components.Drawer 
    {
        id: drawer

        settingsContent: ColumnLayout 
        {
            anchors.fill: parent

            TestContent { }

            Item { Layout.fillHeight: true }
        }
    }

    header: Controls.ToolBar 
    {
        id: toolBar

        RowLayout 
        {
            anchors.fill: parent

            Controls.ToolButton 
            {
                text: qsTr("Menu")
                onClicked: drawer.open()
            }

            Item { Layout.fillWidth: true }

            Controls.ToolButton 
            {
                text: qsTr("Pipeline")
                onClicked: pipelineMenu.open()

                Controls.Menu {
                    id: pipelineMenu
                    y: toolBar.height

                    Controls.MenuItem { text: qsTr("Details") }
                    Controls.MenuItem { text: qsTr("Edit") }
                }
            }

            Controls.ToolButton 
            {
                text: qsTr("Tools")
                onClicked: toolsMenu.open()

                Controls.Menu 
                {
                    id: toolsMenu
                    y: toolBar.height

                    Controls.MenuItem { text: qsTr("Record") }
                    Controls.MenuItem { text: qsTr("Take Screenshot") }
                }
            }

            Controls.ToolButton 
            {
                text: qsTr("View")
                onClicked: viewMenu.open()

                Controls.Menu 
                {
                    id: viewMenu
                    y: toolBar.height

                    Controls.MenuItem 
                    { 
                        text: bottomPanelView.isPanelVisible() ? qsTr("Hide Console") : qsTr("Show Console")
                        onTriggered: bottomPanelView.togglePanel()
                    }

                    Controls.MenuItem 
                    {
                        text: leftPanelView.isPanelVisible() ? qsTr("Hide Side Panel") : qsTr("Show Side Panel")
                        onTriggered: leftPanelView.togglePanel()
                    }
                }
            }

            Controls.ToolButton
            {
                text: (fsStateWrapper.state == "normalScreen") ? qsTr("Fullscreen") : qsTr("Normal screen")
                onClicked: window.toggleFullScreenMode()
            }
        }
    }

    Components.BottomPanelView 
    {
        id: bottomPanelView

        anchors.fill: parent

        Components.LeftPanelView 
        {
            id: leftPanelView

            anchors.fill: parent

            TestContent { }

            panel.minimumWidth: 240

            panelContent: Components.ScrollableFlickable 
            {
                anchors.fill: parent

                flickableDirection: Flickable.VerticalFlick
                boundsBehavior: Flickable.StopAtBounds

                contentHeight: propertyEditor.height
                contentWidth: propertyEditor.width
            
                PropertyEditor.PropertyEditor 
                {
                    id: propertyEditor

                    pipelineInterface: Qt.createComponent("PipelineDummy.qml").createObject(propertyEditor);
                    path: 'root'

                    Component.onCompleted: propertyEditor.update()
                }

                verticalScrollbar: true
            }
        }

        panel.minimumHeight: 150

        panelContent: ColumnLayout 
        {
            anchors.fill: parent

            Components.Console 
            {
                id: console_view

                anchors.left: parent.left
                anchors.right: parent.right

                rightPadding: 0

                Layout.minimumHeight: 50
                Layout.fillHeight: true

                MessageForwarder 
                {
                    id: message_forwarder

                    onMessageReceived: 
                    {
                        var stringType;
                        if (type == MessageForwarder.Debug)
                            stringType = "Debug";
                        else if (type == MessageForwarder.Warning)
                            stringType = "Warning"; 
                        else if (type == MessageForwarder.Critical)
                            stringType = "Critical";
                        else if (type == MessageForwarder.Fatal)
                            stringType = "Fatal";

                        console_view.append(message, stringType);
                    }
                }
            }

            Components.CommandLine 
            {
                id: command_line

                anchors.left: parent.left
                anchors.right: parent.right

                autocompleteModel: ["console", "string", "for", "while"]

                onSubmitted: 
                {
                    console_view.append("> " + command + "\n", "Command");
                    var res = eval(command);

                    if (res != undefined)
                        console.log(res);
                }
            }
        }
    }

    Labs.Settings 
    {
        id: settings
        property int width: 800
        property int height: 600
        property int x
        property int y
    }

    Component.onDestruction: 
    {
        settings.x = x;
        settings.y = y;
        settings.width = width;
        settings.height = height;
    }
}
