from json import JSONDecoder
from hashlib import md5
import requests

json = JSONDecoder()

def get_user_info(uid):
	req = requests.get("http://mete/users/{}.json".format(uid))
	content = json.decode(req.text)
	assert content["id"] == uid
	return {
		"name": content["name"],
		"id": content["id"],
		"balance": content["balance"]
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

def get_user_info2(uid): #offline debugging
	return {
		"name": "A",
		"id": 0,
		"balance": 10
	}

def get_drinks2(): #offline debugging
	return [{
		"id": 0,
		"name": "Mate",
		"bottle_size": 0.5,
		"caffeine": True,
		"donation_recommended": 1.5,
		"logo": ""
	}]

def buy_drink2(uid, amount):
	pass
