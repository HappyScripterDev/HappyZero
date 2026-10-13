import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root
    width: parent.width
    height: parent.height
    
    property bool activatedInCalamares: false
    
    Rectangle {
        anchors.fill: parent
        color: "#F8F9FA"
    }
    
    Column {
        anchors.centerIn: parent
        spacing: 24
        width: parent.width * 0.8
        
        Image {
            source: "welcome.svg"
            width: 320
            height: 80
            fillMode: Image.PreserveAspectFit
            anchors.horizontalCenter: parent.horizontalCenter
        }
        
        Text {
            text: "Welcome to Happy Zero"
            font.pointSize: 24
            font.family: "Ubuntu, Cantarell, sans-serif"
            color: "#1F1F1F"
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
        }
        
        Text {
            text: "Happy Zero is a clean, modern Linux distribution based on Ubuntu 24.04 LTS.\n\nThis installer will guide you through setting up Happy Zero on your computer."
            font.pointSize: 12
            font.family: "Ubuntu, Cantarell, sans-serif"
            color: "#5F6368"
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
            wrapMode: Text.WordWrap
            lineHeight: 1.5
        }
    }
    
    function onActivate() {
        root.activatedInCalamares = true
    }
    
    function onLeave() {
        root.activatedInCalamares = false
    }
}
