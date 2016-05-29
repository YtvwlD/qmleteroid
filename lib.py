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
		"id": content["id"],
		"name": content["name"],
		"balance": content["balance"],
		"email": content["email"],
		"portrait": "http://gravatar.com/avatar/{}".format(md5(content["email"].strip().lower().encode()).hexdigest())
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
	req = requests.get("http://mete/users/{}/deposit?amount=-{}".format(uid, amount))
