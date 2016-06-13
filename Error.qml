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
	Rectangle
	{
		id: errorRect
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.margins: 30
		height: parent.height - buttonsRect.height
		Text
		{
			id: labelText
			text: "An error occurred.\nPlease check your connection and the set hostname.\nDetailed error message:"
		}
		Flickable
		{
			y: labelText.height
			width: parent.width
			height: parent.height - labelText.height
			contentWidth: exceptionText.width
			contentHeight: exceptionText.height
			clip: true
			Text
			{
				id: exceptionText
				text: py.errorText
			}
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
			id: backButton
			width: parent.width
			action: backAction
		}
	}
	Action
	{
		id: backAction
		text: "&Back"
		//shortcut
		//iconName
		onTriggered:
		{
			console.log("Error screen: Going back to: " + pageLoader.oldurl);
			pageLoader.source = pageLoader.oldurl;
			pageLoader.oldurl = "";
		}
	}
}
