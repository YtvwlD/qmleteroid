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
import QtQuick.Layouts 1.2
import "lib.js" as Library

Rectangle
{
	Rectangle
	{
		id: imageRect
		anchors.top: parent.top
		anchors.bottom: settingsRect.top
		anchors.left: parent.left
		anchors.right: parent.right
		Image
		{
			anchors.fill: parent
			anchors.margins: 40
			//width: 140
			//height: 140
			fillMode: Image.PreserveAspectFit
			source: user.portrait
		}
	}
	GridLayout
	{
		id: settingsRect
		columns: 2
		columnSpacing: 20
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: buttonsRect.top
		anchors.margins: 30
		Text
		{
			text: "ID (not changable):"
		}
		Text
		{
			id: uid_text
			text: user.uid
		}
		Text
		{
			text: "Name:"
		}
		TextField
		{
			id: name_edit
			Layout.fillWidth: true
		}
		Text
		{
			text: "Email:"
		}
		TextField
		{
			id: email_edit
			Layout.fillWidth: true
			onEditingFinished: user.refreshGravatar()
		}
		Text
		{
			text: "Balance:"
		}
		TextField
		{
			id: balance_edit
			Layout.fillWidth: true
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
			if(user.uid == -1) //new user
			{
				console.log("Creating new user: " + user.name);
				Library.add_user(globalSettings.url, user.name, user.balance, user.email, function(result)
				{
					if(result)
					{
						globalSettings.uid = result["id"];
						pageLoader.source = "BuyDrink.qml";
					}
				});
			}
			else
			{
				console.log("Saving changes to user: " + user.name);
			Library.save_user_data(globalSettings.url, user.uid, user.name, user.balance, user.email, function(result)
				{
					//TODO: check if everything went right
					pageLoader.source = "BuyDrink.qml";
				});
			}
		}
	}
	Action
	{
		id: cancelAction
		text: "&Cancel"
		shortcut: StandardKey.Escape
		iconName: "go-previous"
		onTriggered:
		{
			if(user.uid == -1) //new user
			{
				pageLoader.source = "PickUsername.qml";
			}
			else
			{
				pageLoader.source = "BuyDrink.qml";
			}
		}
	}
	Item
	{
		id: user
		property double balance: parseFloat(balance_edit.text)
		property int uid: globalSettings.uid
		property alias name: name_edit.text
		property string portrait: ""
		property alias email: email_edit.text
		function refreshGravatar()
		{
			user.portrait = Library.get_gravatar_url(user.email);
		}
	}
	Component.onCompleted:
	{
		if (user.uid != -1) //existing user
		{
			Library.get_user_data(globalSettings.url, user.uid, function(result)
			{
				if(result)
				{
					console.log("Got information for user " + user.uid + ".");
					name_edit.text = result["name"];
					balance_edit.text = result["balance"];
					email_edit.text = result["email"];
					user.refreshGravatar();
				}
			});
		}
		else
		{
			user.refreshGravatar();
		}
	}
}
