import QtQuick 2.5
import io.thp.pyotherside 1.4
import QtQuick.Controls 1.4

Rectangle
{
	id: root
	width: 360
	height: 360
	Rectangle
	{
		width: root.width
		height: switchUserButton.height
		Text
		{
			id: label
			text: "Loading..."
			height: parent.height
			width: root.width - switchUserButton.width
			verticalAlignment: Text.AlignVCenter
			horizontalAlignment: Text.AlignHCenter
		}
		Button
		{
			id: switchUserButton
			x: label.width
			action: switchUserAction
		}
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
				property string drink_name: name
				property double price: donation_recommended
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
		id: switchUserAction
		text: "S&witch"
		//iconName: ""
		//shortcut
		onTriggered:
		{
			console.log("Switching user...");
			pageLoader.source = "PickUsername.qml";
		}
	}
	Action
	{
		id: buyAction
		text: "&Buy"
		shortcut: StandardKey.Enter
		//iconName: ""
		onTriggered:
		{
			console.log("Buying " + drinksGrid.currentItem.drink_name + " for " + drinksGrid.currentItem.price + "€...");
			//TODO
			py.call("BuyDrink.buy_drink2", [user.uid, drinksGrid.currentItem.price], function()
			{
				console.log("Bought " + drinksGrid.currentItem.drink_name + " for " + drinksGrid.currentItem.price + "€.");
				user.balance = user.balance - drinksGrid.currentItem.price;
				console.log("New balance: " + user.balance + "€");
				user.refreshDisplay();
			})
		}
	}
	Item
	{
		id: user
		property double balance: 0.00
		property int uid: globalSettings.uid
		property string name: ""
		function refreshDisplay()
		{
			label.text = "Buy drinks for %1 (balance: %2€):".arg(user.name).arg(user.balance);
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
				py.call("BuyDrink.get_user_info2", [user.uid], function(result)
				{
					console.log("Got information for user " + user.uid + ".");
					user.name = result["name"];
					user.balance = result["balance"];
					user.refreshDisplay();
				});
			});
		}
	}
}
