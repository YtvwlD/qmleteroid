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
import "lib.js" as Library

Rectangle
{
	Rectangle
	{
		width: parent.width
		height: addUserButton.height
		Text
		{
			id: label
			text: "Select your account:"
			height: parent.height
			width: parent.width - addUserButton.width - changeURLButton.width
			verticalAlignment: Text.AlignVCenter
			horizontalAlignment: Text.AlignHCenter
		}
		Button
		{
			id: addUserButton
			x: label.width
			action: addUserAction
		}
		Button
		{
			id: changeURLButton
			x: label.width + addUserButton.width
			action: changeURLAction
		}
	}
	Rectangle
	{
		id: usersRect
		y: label.height
		width: parent.width
		height: parent.height - label.height - saveButton.height
		GridView
		{
			id: usersGrid
			anchors.fill: parent
			anchors.margins: 20
			clip: true
			cellWidth: 140 + 10 //margin
			cellHeight: 140 + 30 // the text
			highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
			focus: true
			model: usersModel
			delegate: Column
			{
				property int uid: id
				Image
				{
					width: 140
					height: 140
					fillMode: Image.PreserveAspectFit
					source: portrait
					anchors.horizontalCenter: parent.horizontalCenter
					MouseArea
					{
						anchors.fill: parent
						onClicked: usersGrid.currentIndex = index
					}
				}
				Text
				{
					text: name
					anchors.horizontalCenter: parent.horizontalCenter
				}
			}
		}
	}
	Button
	{
		id: saveButton
		width: parent.width
		y: label.height + usersRect.height
		action: saveAction
	}
	Action
	{
		id: saveAction
		text: "&Save"
		shortcut: StandardKey.Enter
		iconName: "go-next"
		onTriggered:
		{
			console.log("Saving uid: " + usersGrid.currentItem.uid);
			globalSettings.uid = usersGrid.currentItem.uid;
			pageLoader.source = "BuyDrink.qml";
		}
	}
	Action
	{
		id: addUserAction
		text: "&Add"
		//shortcut
		iconName: "contact-new"
		onTriggered:
		{
			globalSettings.uid = -1;
			pageLoader.source = "UserSettings.qml";
		}
	}
	Action
	{
		id: changeURLAction
		text: "Change &URL"
		//shortcut
		iconName: "preferences-other"
		onTriggered: pageLoader.source = "ChangeURL.qml"
	}
	ListModel
	{
		id: usersModel
	}
	Component.onCompleted:
	{
		Library.get_users_data(globalSettings.url, function(result)
		{
			// Load the received data into the list model
			for (var i=0; i<result.length; i++)
			{
				usersModel.append(result[i]);
			}
			console.log("Got list of users.");
			console.log("Saved uid is: " + globalSettings.uid);
			// Restore the saved settings
			usersGrid.highlightFollowsCurrentItem = false;
			var found = false;
			for (usersGrid.currentIndex = 0; usersGrid.currentIndex < usersGrid.count; usersGrid.currentIndex++)
			{
				if (usersGrid.currentItem.uid == globalSettings.uid)
				{
					found = true;
					break;
				}
			}
			if (!found)
			{
				usersGrid.currentIndex = -1;
			}
			usersGrid.highlightFollowsCurrentItem = true;
		});
	}
}
