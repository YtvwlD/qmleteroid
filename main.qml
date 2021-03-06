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
	Python
	{
		//via https://pyotherside.readthedocs.io/en/latest/#loading-listmodel-data-from-python
		id: py
		property string errorText: ""
		property bool isError: false
		Component.onCompleted:
		{
			// Add the directory of this .qml file to the search path
			addImportPath(Qt.resolvedUrl('.'));
			// Import the main module and load the data
			importModule('lib', function()
			{
				//globalSettings.uid = -1;
				console.log("uid: " + globalSettings.uid);
				pageLoader.source = globalSettings.uid == -1 ? "PickUsername.qml" : "BuyDrink.qml";
			});
		}
		onError:
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
		}
	}
}
