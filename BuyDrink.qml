import QtQuick 2.5
import io.thp.pyotherside 1.4
import Qt.labs.settings 1.0
import QtQuick.Controls 1.4

Rectangle
{
	id: root
	width: 360
	height: 360
	Text
	{
		id: label
		text: "Buy drinks for {}:"
		height: 25
		width: root.width
		verticalAlignment: Text.AlignVCenter
		horizontalAlignment: Text.AlignHCenter
	}
	Rectangle
	{
		id: drinksRect
		y: label.height
		width: root.width
		height: root.height - label.height - buyButton.height
		GridView
		{
			id: drinksGrid
			anchors.fill: parent
			anchors.margins: 20
			clip: true
			cellWidth: 140 + 10 //margin
			cellHeight: 140 + 30 // the text
			highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
			focus: true
			model: drinksModel
			delegate: Column
			{
				property int did: id
				Image
				{
					width: 140
					height: 140
					fillMode: Image.PreserveAspectFit
					source: logo
					anchors.horizontalCenter: parent.horizontalCenter
					MouseArea
					{
						anchors.fill: parent
						onClicked: drinksGrid.currentIndex = index
					}
				}
				Text
				{
					text: name
					anchors.horizontalCenter: parent.horizontalCenter
				}
				Text
				{
					text: "%1 caffeine".arg(caffeine ? "w/" : "w/o")
					anchors.horizontalCenter: parent.horizontalCenter
				}
				Text
				{
					text: "%1 l".arg(bottle_size)
					anchors.horizontalCenter: parent.horizontalCenter
				}
				Text
				{
					text: "%1 €".arg(donation_recommended)
					anchors.horizontalCenter: parent.horizontalCenter
				}
			}
		}
	}
	Button
	{
		id: buyButton
		width: root.width
		y: label.height + drinksRect.height
		action: buyAction
	}
	Action
	{
		id: buyAction
		text: "&Buy"
		shortcut: StandardKey.Enter
		//iconName: ""
		onTriggered:
		{
			console.log("TODO: Buying: " + drinksGrid.currentItem.did);
			//TODO
		}
	}
	ListModel
	{
		id: drinksModel
	}
	Python
	{
		//via https://pyotherside.readthedocs.io/en/latest/#loading-listmodel-data-from-python
		id: py
		Component.onCompleted:
		{
			// Add the directory of this .qml file to the search path
			addImportPath(Qt.resolvedUrl('.'));
			// Import the main module and load the data
			importModule('BuyDrink', function ()
			{
				py.call('BuyDrink.get_drinks2', [], function(result)
				{
					// Load the received data into the list model
					for (var i=0; i<result.length; i++)
					{
						drinksModel.append(result[i]);
					}
					console.log("Got list of drinks.");
				});
			});
		}
	}
}
