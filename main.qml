import QtQuick 2.5
import Qt.labs.settings 1.0
import io.thp.pyotherside 1.4


Item
{
	id: window
	width: 360
	height: 360
	Loader
	{
		// Explicitly set the size of the
		// Loader to the parent item's size
		anchors.fill: parent
		id: pageLoader
	}
	Settings
	{
		id: globalSettings
		property int uid: -1
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
		Component.onCompleted:
		{
			// Add the directory of this .qml file to the search path
			addImportPath(Qt.resolvedUrl('.'));
			// Import the main module and load the data
			importModule('lib2', function()
			{
				//globalSettings.uid = -1;
				console.log("uid: " + globalSettings.uid);
				pageLoader.source = globalSettings.uid == -1 ? "PickUsername.qml" : "BuyDrink.qml";
			});
		}
	}
}
