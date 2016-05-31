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
	Text
	{
		id: label
		text: "Please enter the URL of your Mete installation:"
		height: 30
		width: root.width
		verticalAlignment: Text.AlignVCenter
		horizontalAlignment: Text.AlignHCenter
	}
	Rectangle
	{
		id: settingsRect
		anchors.top: label.bottom
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.margins: 30
		height: parent.height - buttonsRect.height
		Text
		{
			text: "URL:"
			width: root.width/2
		}
		TextInput
		{
			id: urlinput
			x: root.width/2
			width: root.width/2
			text: "http://"
			Component.onCompleted: this.text = globalSettings.url
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
			x: root.width/2
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
			var url = urlinput.text;
			if(url.substr(-1) === '/') //remove the trailing slash
			{
				url = url.substr(0, url.length - 1);
			}
			console.log("Saving URL: " + url);
			globalSettings.url = url;
			//TODO: Do we need to reset the saved uid here?
			pageLoader.source = "PickUsername.qml";
		}
	}
	Action
	{
		id: cancelAction
		text: "&Cancel"
		shortcut: StandardKey.Escape
		iconName: "Cancel"
		onTriggered: pageLoader.source = "PickUsername.qml"
	}
}