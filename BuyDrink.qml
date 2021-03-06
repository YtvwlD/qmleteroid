// QMLeteroid - a QML clone of https://github.com/chaosdorf/meteroid
// Copyright (C) 2016 Niklas Sombert
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

import QtQuick 2.5
import QtQuick.Controls 1.4

Rectangle
{
	Rectangle
	{
		width: parent.width
		height: switchUserButton.height
		Text
		{
			id: label
			text: "Loading..."
			height: parent.height
			width: parent.width - switchUserButton.width - editUserButton.width
			verticalAlignment: Text.AlignVCenter
			horizontalAlignment: Text.AlignHCenter
		}
		Button
		{
			id: switchUserButton
			x: label.width
			action: switchUserAction
		}
		Button
		{
			id: editUserButton
			x: label.width + switchUserButton.width
			action: editUserAction
		}
	}
	Rectangle
	{
		id: drinksRect
		y: label.height
		width: parent.width
		height: parent.height - label.height - buyButton.height
		GridView
		{
			id: drinksGrid
			anchors.fill: parent
			anchors.margins: 15
			clip: true
			cellWidth: 140 + 20 //margin
			cellHeight: 140 + 60 // the text
			highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
			focus: true
			model: drinksModel
			delegate: Column
			{
				property int did: id
				property string drink_name: name
				property double price: donation_recommendation
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
					wrapMode: Text.WrapAnywhere
					width: parent.width
					horizontalAlignment: Text.AlignHCenter
				}
				Text
				{
					text: "%1 €".arg(donation_recommendation)
					width: parent.width
					horizontalAlignment: Text.AlignHCenter
				}
			}
		}
	}
	Button
	{
		id: buyButton
		width: parent.width
		y: label.height + drinksRect.height
		action: buyAction
	}
	Action
	{
		id: switchUserAction
		text: "S&witch"
		iconName: "go-previous"
		onTriggered:
		{
			console.log("Switching user...");
			pageLoader.source = "PickUsername.qml";
		}
	}
	Action
	{
		id: editUserAction
		text: "&Edit"
		iconName: "preferences-other"
		onTriggered:
		{
			console.log("Editing user " + user.name + "...");
			pageLoader.source = "UserSettings.qml";
		}
	}
	Action
	{
		id: buyAction
		text: "&Buy"
		iconName: "go-next"
		onTriggered:
		{
			console.log("Buying " + drinksGrid.currentItem.drink_name + " for " + drinksGrid.currentItem.price + "€...");
			//TODO
			py.call("lib.buy_drink", [globalSettings.url, user.uid, drinksGrid.currentItem.did], function()
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
	Component.onCompleted:
	{
		py.call('lib.get_drinks', [globalSettings.url], function(result)
		{
			if(result)
			{
				// Load the received data into the list model
				for (var i=0; i<result.length; i++)
				{
					drinksModel.append(result[i]);
				}
				console.log("Got list of drinks.");
			}
		});
		py.call("lib.get_user_data", [globalSettings.url, user.uid], function(result)
		{
			if(result)
			{
				console.log("Got information for user " + user.uid + ".");
				user.name = result["name"];
				user.balance = result["balance"];
				user.refreshDisplay();
			}
		});
	}
}
