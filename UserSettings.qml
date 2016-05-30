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
	id: root
	width: 360
	height: 360
	Rectangle
	{
		id: imageRect
		width: root.width
		height: root.height - buttonsRect.height - settingsRect.height
		Image
		{
			anchors.fill: imageRect
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
			width: root.width/2
		}
		Text
		{
			id: uid_text
			x: root.width/2
			text: user.uid
		}
		Text
		{
			y: uid_text.height
			text: "Name:"
			width: root.width/2
		}
		TextInput
		{
			id: name_edit
			text: user.name
			x: root.width/2
			y: uid_text.height
			width: root.width/2
		}
		Text
		{
			y: uid_text.height + name_edit.height
			text: "Email:"
			width: root.width/2
		}
		TextInput
		{
			id: email_edit
			text: user.email
			x: root.width/2
			y: uid_text.height + name_edit.height
			width: root.width/2
		}
		Text
		{
			y: uid_text.height + name_edit.height + email_edit.height
			text: "Balance:"
			width: root.width/2
		}
		TextInput
		{
			text: user.balance
			x: root.width/2
			y: uid_text.height + name_edit.height + email_edit.height
			width: root.width/2
		}
	}
	Rectangle
	{
		id: buttonsRect
		y: root.height - this.height
		width: root.width
		height: 40
		Button
		{
			id: okButton
			width: root.width/2
			action: okAction
		}
		Button
		{
			id: cancelButton
			width: root.width/2
			x: okButton.width
			action: cancelAction
		}
	}
	Action
	{
		id: okAction
		text: "O&k"
		shortcut: StandardKey.Enter
		iconName: "Ok"
		onTriggered:
		{
			py.call("lib2.save_user_data", [user.uid, user.name, user.balance, user.email], function(result)
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
		iconName: "Cancel"
		onTriggered: pageLoader.source = "BuyDrink.qml"
	}
	Item
	{
		id: user
		property double balance: 0.00
		property int uid: globalSettings.uid
		property string name: ""
		property string portrait: ""
		property string email: ""
	}
	Component.onCompleted:
	{
		py.call("lib2.get_user_data", [user.uid], function(result)
		{
			console.log("Got information for user " + user.uid + ".");
			user.name = result["name"];
			user.balance = result["balance"];
			user.email = result["email"];
			user.portrait = result["portrait"];
		});
	}
}
