// Version 3

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

RowLayout {
	id: configSpinBox

    property string configKey: ''
	readonly property var configValue: configKey ? plasmoid.configuration[configKey] : 0
    // TODO: decimals has been removed and potentially migrated to QDoubleSpinBox
    // property alias decimals: spinBox.decimals
    // property alias horizontalAlignment: spinBox.horizontalAlignment
    property alias maximumValue: spinBox.to
    property alias minimumValue: spinBox.from
    property alias prefix: spinBox.prefix
    property alias stepSize: spinBox.stepSize
    property alias suffix: spinBox.suffix
	property alias value: spinBox.value

	property alias before: labelBefore.text
	property alias after: labelAfter.text

	Label {
		id: labelBefore
		text: ""
		visible: text
	}
	
	SpinBox {
        property string suffix
        property string prefix

        id: spinBox

        value: configSpinBox.configValue
		onValueChanged: serializeTimer.start()

        textFromValue: function(value) { return prefix + " " + value + " " + suffix; }
        valueFromText: function(text) { return Number(text.split(" ")[1]); }
        to: 2147483647
	}

	Label {
		id: labelAfter
		text: ""
		visible: text
	}

	Timer { // throttle
		id: serializeTimer
		interval: 300
		onTriggered: {
            if (configSpinBox.configKey) {
				plasmoid.configuration[configKey] = value
			}
		}
	}
}
