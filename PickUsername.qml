import QtQuick 2.5
import io.thp.pyotherside 1.4
import Qt.labs.settings 1.0
import QtQuick.Controls 1.4

Rectangle
{
	id: root
	width: 360
	height: 360
	Text
	{
		id: label
		text: "Select your account:"
		height: 25
		width: root.width
		verticalAlignment: Text.AlignVCenter
		horizontalAlignment: Text.AlignHCenter
	}
	Rectangle
	{
		id: usersRect
		y: label.height
		width: root.width
		height: root.height - label.height - saveButton.height
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
		width: root.width
		y: label.height + usersRect.height
		text: "Save"
		action: saveAction
	}
	Action
	{
		id: saveAction
		text: "&Save"
		shortcut: StandardKey.Enter
		iconName: "save"
		onTriggered:
		{
			console.log("Saving uid: " + usersGrid.currentItem.uid);
			userSelectSettings.uid = usersGrid.currentItem.uid;
		}
	}
	Settings
	{
		id: userSelectSettings
		property int uid: -1
	}
	ListModel
	{
		id: usersModel
	}
	Python
	{
		//via https://pyotherside.readthedocs.io/en/latest/#loading-listmodel-data-from-python
		id: py
		Component.onCompleted:
		{
			// Add the directory of this .qml file to the search path
			addImportPath(Qt.resolvedUrl('.'));
			// Import the main module and load the data
			importModule('PickUsername', function ()
			{
				py.call('PickUsername.get_data2', [], function(result)
				{
					// Load the received data into the list model
					for (var i=0; i<result.length; i++)
					{
						usersModel.append(result[i]);
					}
					console.log("Got list of users.");
					console.log("Saved uid is: " + userSelectSettings.uid);
					// Restore the saved settings
					usersGrid.highlightFollowsCurrentItem = false;
					var found = false;
					for (usersGrid.currentIndex = 0; usersGrid.currentIndex < usersGrid.count; usersGrid.currentIndex++)
					{
						if (usersGrid.currentItem.uid == userSelectSettings.uid)
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
			});
		}
	}
}
