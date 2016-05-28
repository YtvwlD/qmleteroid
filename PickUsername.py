from json import JSONDecoder
from hashlib import md5
import requests

def get_data():
	json = JSONDecoder()
	req = requests.get("http://mete/users.json")
	content = json.decode(req.text)
	results = []
	for element in content:
		results.append({
			"name": element["name"],
			#via https://github.com/alekstorm/pygravatar/blob/master/gravatar.py#L14
			"portrait": "http://gravatar.com/avatar/{}".format(md5(element["email"].strip().lower().encode()).hexdigest())
		})
	return results

def get_data2(): #offline debugging
	return [
		{"name": "A", "portrait": "/usr/share/ubuntu-html5-ui-toolkit/0.1/ambiance/img/avatar_contacts_list@8.png"},
		{"name": "B", "portrait": "/usr/share/ubuntu-html5-ui-toolkit/0.1/ambiance/img/avatar_contacts_list@8.png"},
		{"name": "C", "portrait": "/usr/share/ubuntu-html5-ui-toolkit/0.1/ambiance/img/avatar_contacts_list@8.png"}
	]
