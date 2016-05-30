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

from json import JSONDecoder
from hashlib import md5
import requests

json = JSONDecoder()

def get_users_data():
	req = requests.get("http://mete/users.json")
	content = json.decode(req.text)
	results = []
	for element in content:
		results.append(_parseUser(element))
	return results

def get_user_data(uid):
	req = requests.get("http://mete/users/{}.json".format(uid))
	content = json.decode(req.text)
	assert content["id"] == uid
	return _parseUser(content)

def save_user_data(uid, name, balance, email):
	d = {
		"name": name,
		"email": email,
		"balance": balance
	}
	requests.put("http://mete/users/{}.json".format(uid), data=d)

def add_user(name, balance, email):
	p = {
		"name": name,
		"balance": balance,
		"email": email
	}
	requests.post("http://mete/users", params=p)

def _parseUser(data):
	return {
		"id": data["id"],
		"name": data["name"],
		"balance": data["balance"],
		"email": data["email"],
		"portrait": "http://gravatar.com/avatar/{}".format(md5(data["email"].strip().lower().encode()).hexdigest())
	}

def get_drinks():
	req = requests.get("http://mete/drinks.json")
	content = json.decode(req.text)
	results = []
	for element in content:
		results.append({
			"id": int(element["id"]),
			"name": element["name"],
			"bottle_size": element["bottle_size"],
			"caffeine": element["caffeine"],
			"donation_recommended": element["donation_recommended"],
			"logo": ("http://mete/{}".format(element["logo_url"])) if element["logo_url"] else ""
		})
	return results

def buy_drink(uid, amount):
	requests.get("http://mete/users/{}/deposit?amount=-{}".format(uid, amount))
