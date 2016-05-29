import QtQuick 2.5
import Qt.labs.settings 1.0

Item
{
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
	}
	Component.onCompleted:
	{
		Qt.application.name = "QMLeteroid";
		Qt.application.organization = "Chaosdorf";
		Qt.application.domain = "chaosdorf.de";
		//globalSettings.uid = -1;
		console.log("uid: " + globalSettings.uid);
		pageLoader.source = globalSettings.uid == -1 ? "PickUsername.qml" : "BuyDrink.qml";
	}
}
