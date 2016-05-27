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
