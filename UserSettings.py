from json import JSONDecoder
from hashlib import md5
import requests

def get_user_info(uid):
	json = JSONDecoder()
	req = requests.get("http://mete/users/{}.json".format(uid))
	content = json.decode(req.text)
	assert content["id"] == uid
	return {
		"name": content["name"],
		"id": content["id"],
		"balance": content["balance"],
		"email": content["email"],
		"portrait": "http://gravatar.com/avatar/{}".format(md5(content["email"].strip().lower().encode()).hexdigest())
	}

def get_user_info2(uid): #offline debugging
	return {
		"name": "A",
		"id": 0,
		"balance": 10,
		"email": "mail@example.net",
		"portrait": "/usr/share/ubuntu-html5-ui-toolkit/0.1/ambiance/img/avatar_contacts_list@8.png"
	}
