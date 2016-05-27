import QtQuick 2.5
import io.thp.pyotherside 1.4

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
		y: label.height
		width: root.width
		height: root.height - label.height
		GridView
		{
			anchors.fill: parent
			anchors.margins: 20
			clip: true
			cellWidth: 140 + 10 //margin
			cellHeight: 140 + 30 // the text
			model: usersModel
			delegate: Column
			{
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
				py.call('PickUsername.get_data', [], function(result)
				{
					// Load the received data into the list model
					for (var i=0; i<result.length; i++)
					{
						usersModel.append(result[i]);
					}
				});
			});
		}
	}
}
