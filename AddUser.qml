import QtQuick 2.5
import QtQuick.Controls 1.4

Rectangle
{
	id: root
	width: 360
	height: 360
	Rectangle
	{
		id: settingsRect
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.margins: 30
		height: parent.height - buttonsRect.height
		Text
		{
			text: "Name:"
			width: root.width/2
		}
		TextInput
		{
			id: name_edit
			text: user.name
			x: root.width/2
			width: root.width/2
		}
		Text
		{
			y: name_edit.height
			text: "Email:"
			width: root.width/2
		}
		TextInput
		{
			id: email_edit
			text: user.email
			x: root.width/2
			y: name_edit.height
			width: root.width/2
		}
		Text
		{
			y: name_edit.height + email_edit.height
			text: "Balance:"
			width: root.width/2
		}
		TextInput
		{
			text: user.balance
			x: root.width/2
			y: name_edit.height + email_edit.height
			width: root.width/2
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
			x: okButton.width
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
			py.call("lib2.add_user", [user.name, user.balance, user.email], function(result)
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
		iconName: "Cancel"
		onTriggered: pageLoader.source = "PickUsername.qml"
	}
	Item
	{
		id: user
		property double balance: 0.00
		property string name: ""
		property string portrait: ""
		property string email: ""
	}
}
