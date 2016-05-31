# QMLeteroid - a QML clone of https://github.com/chaosdorf/meteroid
# Copyright (C) 2016 Niklas Sombert
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

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

def get_users_data(url):
	return fake_users_list

def get_user_data(url, uid):
	return fake_users_list[uid]

def save_user_data(url, uid, name, balance, email):
	print("This is not real.")

def add_user(url, name, balance, email):
	print("This is not real.")

def get_drinks(url):
	return [{
		"id": 0,
		"name": "Mate",
		"bottle_size": 0.5,
		"caffeine": True,
		"donation_recommendation": 1.5,
		"logo": ""
	}]

def buy_drink(url, uid, amount):
	print("This is not real.")
