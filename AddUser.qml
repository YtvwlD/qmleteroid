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

Rectangle
{
	GridLayout
	{
		id: settingsRect
		columns: 2
		columnSpacing: 20
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.margins: 30
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
			console.log("Creating new user: " + user.name);
			py.call("lib.add_user", [globalSettings.url, user.name, user.balance, user.email], function(result)
			{
				//TODO: check if everything went right
				pageLoader.source = "PickUsername.qml";
			});
		}
	}
	Action
	{
		id: cancelAction
		text: "&Cancel"
		shortcut: StandardKey.Escape
		iconName: "go-previous"
		onTriggered: pageLoader.source = "PickUsername.qml"
	}
	Item
	{
		id: user
		property double balance: parseFloat(balance_edit.text)
		property string name: name_edit.text
		property string portrait: "" //TODO: Show Gravatar?
		property string email: email_edit.text
	}
}
