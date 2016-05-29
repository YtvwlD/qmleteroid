fake_users_list = [
	{
		"id": 0,
		"name": "A",
		"balance": 10,
		"email": "mail@example.com",
		"portrait": "/usr/share/ubuntu-html5-ui-toolkit/0.1/ambiance/img/avatar_contacts_list@8.png",
	},
	{
		"id": 1,
		"name": "B",
		"balance": 5,
		"email": "mail@example.net",
		"portrait": "/usr/share/ubuntu-html5-ui-toolkit/0.1/ambiance/img/avatar_contacts_list@8.png",
	},
	{
		"id": 2,
		"name": "C",
		"balance": 2.50,
		"email": "mail@example.org",
		"portrait": "/usr/share/ubuntu-html5-ui-toolkit/0.1/ambiance/img/avatar_contacts_list@8.png",
	},
]

def get_users_data():
	return fake_users_list

def get_user_data(uid):
	return fake_users_list[uid]

def get_drinks():
	return [{
		"id": 0,
		"name": "Mate",
		"bottle_size": 0.5,
		"caffeine": True,
		"donation_recommended": 1.5,
		"logo": ""
	}]

def buy_drink(uid, amount):
	print("This is not real.")
