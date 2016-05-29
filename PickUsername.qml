import QtQuick 2.5
import QtQuick.Controls 1.4

Rectangle
{
	id: root
	width: 360
	height: 360
	Rectangle
	{
		width: root.width
		height: addUserButton.height
		Text
		{
			id: label
			text: "Select your account:"
			height: parent.height
			width: root.width - addUserButton.width
			verticalAlignment: Text.AlignVCenter
			horizontalAlignment: Text.AlignHCenter
		}
		Button
		{
			id: addUserButton
			x: label.width
			action: addUserAction
		}
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
		width: root.width
		y: label.height + usersRect.height
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
			globalSettings.uid = usersGrid.currentItem.uid;
			pageLoader.source = "BuyDrink.qml";
		}
	}
	Action
	{
		id: addUserAction
		text: "&Add"
		//shortcut
		//iconName
		onTriggered: pageLoader.source = "AddUser.qml"
	}
	ListModel
	{
		id: usersModel
	}
	Component.onCompleted:
	{
	py.call('lib2.get_users_data', [], function(result)
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
