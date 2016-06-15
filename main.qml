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
import QtQuick.Window 2.2
import Qt.labs.settings 1.0
import io.thp.pyotherside 1.4


Window
{
	id: window
	width: 360
	height: 360
	title: "QMLeteroid"
	visible: true
	Loader
	{
		// Explicitly set the size of the
		// Loader to the parent item's size
		anchors.fill: parent
		anchors.margins: 5
		id: pageLoader
		property string oldurl: ""
	}
	Settings
	{
		id: globalSettings
		property int uid: -1
		property string url: "http://mete"
		property alias windowX: window.x
    property alias windowY: window.x
    property alias windowWidth: window.width
    property alias windowHeight: window.height
	}
	Component.onCompleted:
	{
		Qt.application.name = "QMLeteroid";
		Qt.application.organization = "Chaosdorf";
		Qt.application.domain = "chaosdorf.de";
	}
	WorkerScript
	{
		id: lib
		property string errorText: ""
		property bool isError: false
		property var callbacks: {}
		source: "lib.js"
		Component.onCompleted:
		{
			this.callbacks = {};
			console.log("uid: " + globalSettings.uid);
			pageLoader.source = globalSettings.uid == -1 ? "PickUsername.qml" : "BuyDrink.qml";
		}
		/*onError:
		{
			if(!this.isError) //only display one error
			{
				this.isError = true;
				console.log("Error: " + traceback)
				console.log("This has happened in: " + pageLoader.source);
				this.errorText = traceback;
				pageLoader.oldurl = pageLoader.source;
				pageLoader.source = "Error.qml";
			}
		}*/
		onMessage:
		{
			var reply = messageObject;
			console.log("Got a reply: " + reply);
			console.log("Firing the callback with the id: " + reply["rand"]);
			this.callbacks[reply["rand"]](reply["data"]);
			this.callbacks[reply["rand"]] = null;
		}
		function call_async(func, params, callback)
		{
			console.log("Calling: " + func);
			var rand = Math.ceil(Math.random() * 1000000);
			this.callbacks[rand] = callback;
			console.log("rand is: " + rand);
			this.sendMessage({
				"func": func,
				"params": params,
				"rand": rand
			});
		}
	}
}
