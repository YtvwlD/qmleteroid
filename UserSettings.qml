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
		id: imageRect
		width: parent.width
		height: parent.height - buttonsRect.height - settingsRect.height
		Image
		{
			anchors.fill: parent
			anchors.margins: 50
			//width: 140
			//height: 140
			fillMode: Image.PreserveAspectFit
			source: user.portrait
		}
	}
	Rectangle
	{
		id: settingsRect
		y: imageRect.height
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.margins: 30
		height: 100
		Text
		{
			text: "ID (not changable):"
			width: parent.width/2
		}
		Text
		{
			id: uid_text
			x: parent.width/2
			text: user.uid
		}
		Text
		{
			y: uid_text.height
			text: "Name:"
			width: parent.width/2
		}
		TextField
		{
			id: name_edit
			x: parent.width/2
			y: uid_text.height
			width: parent.width/2
		}
		Text
		{
			y: uid_text.height + name_edit.height
			text: "Email:"
			width: parent.width/2
		}
		TextField
		{
			id: email_edit
			text: user.email
			x: parent.width/2
			y: uid_text.height + name_edit.height
			width: parent.width/2
		}
		Text
		{
			y: uid_text.height + name_edit.height + email_edit.height
			text: "Balance:"
			width: parent.width/2
		}
		TextField
		{
			id: balance_edit
			text: user.balance
			x: parent.width/2
			y: uid_text.height + name_edit.height + email_edit.height
			width: parent.width/2
		}
	}
	Rectangle
	{
		id: buttonsRect
		y: parent.height - this.height
		width: parent.width
		height: okButton.height
		Button
		{
			id: okButton
			width: parent.width/2
			action: okAction
		}
		Button
		{
			id: cancelButton
			width: parent.width/2
			x: okButton.width
			action: cancelAction
		}
	}
	Action
	{
		id: okAction
		text: "O&k"
		shortcut: StandardKey.Enter
		iconName: "go-next"
		onTriggered:
		{
			console.log("Saving changes to user: " + user.name);
			py.call("lib.save_user_data", [globalSettings.url, user.uid, user.name, user.balance, user.email], function(result)
			{
				//TODO: check if everything went right
				pageLoader.source = "BuyDrink.qml";
			});
		}
	}
	Action
	{
		id: cancelAction
		text: "&Cancel"
		shortcut: StandardKey.Escape
		iconName: "go-previous"
		onTriggered: pageLoader.source = "BuyDrink.qml"
	}
	Item
	{
		id: user
		property double balance: parseFloat(balance_edit.text)
		property int uid: globalSettings.uid
		property string name: name_edit.text
		property string portrait: "" //TODO: Show Gravatar immediately?
		property string email: email_edit.text
	}
	Component.onCompleted:
	{
		py.call("lib.get_user_data", [globalSettings.url, user.uid], function(result)
		{
			if(result)
			{
				console.log("Got information for user " + user.uid + ".");
				name_edit.text = result["name"];
				balance_edit.text = result["balance"];
				email_edit.text = result["email"];
				user.portrait = result["portrait"];
			}
		});
	}
}
