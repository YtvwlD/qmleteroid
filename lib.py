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

def get_users_data(url):
	req = requests.get("{}/users.json".format(url))
	content = json.decode(req.text)
	results = []
	for element in content:
		results.append(_parseUser(element))
	return results

def get_user_data(url, uid):
	req = requests.get("{}/users/{}.json".format(url, uid))
	content = json.decode(req.text)
	assert content["id"] == uid
	return _parseUser(content)

def save_user_data(url, uid, name, balance, email):
	d = {
		"name": name,
		"email": email,
		"balance": balance
	}
	requests.put("{}/users/{}.json".format(url, uid), data=d)

def add_user(url, name, balance, email):
	p = {
		"name": name,
		"balance": balance,
		"email": email
	}
	requests.post("{}/users".format(url), params=p)

def _parseUser(data):
	return {
		"id": data["id"],
		"name": data["name"],
		"balance": data["balance"],
		"email": data["email"],
		"portrait": "http://gravatar.com/avatar/{}".format(md5(data["email"].strip().lower().encode()).hexdigest())
	}

def get_drinks(url):
	req = requests.get("{}/drinks.json".format(url))
	content = json.decode(req.text)
	results = []
	for element in content:
		results.append({
			"id": int(element["id"]),
			"name": element["name"],
			"bottle_size": element["bottle_size"],
			"caffeine": element["caffeine"],
			"donation_recommendation": element["donation_recommendation"],
			"logo": ("{}/{}".format(url, element["logo_url"])) if element["logo_url"] else ""
		})
	return results

def buy_drink(url, uid, amount):
	requests.get("{}/users/{}/deposit?amount=-{}".format(url, uid, amount))
