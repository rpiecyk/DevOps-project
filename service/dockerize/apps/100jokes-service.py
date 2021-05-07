# - *- coding: utf- 8 - *-
from flask import Flask, jsonify
from flask_restplus import Resource, Api
from bs4 import BeautifulSoup
import requests

app = Flask(__name__)
api = Api(app)

@api.route('/api/v1/jokes', methods=['GET'])
class JokesTop100(Resource):
    def get(self):
        jokes = {}
        number = 1 # jokes counter
        page_num = list(range(1, 6)) # pg nr - 20 jokes per page

        for page in page_num:
            url = "http://bash.org.pl/latest/?page=" + str(page)
            req = requests.get(url)
            page_content = BeautifulSoup(req.content.decode(req.apparent_encoding), "html.parser")

            for joke in page_content.find_all("div", class_="quote post-content post-body"):
                jokes[number] = joke.text
                jokes[number] = jokes[number].replace('\n', '').replace('\t', '').replace('\r', '')
                number += 1
        return jsonify(jokes)

@api.route('/health', methods=['GET'])
class CheckHealth(Resource):
    def get(self):
        return 'healthy'

if __name__ == '__main__':
    app.run(host='0.0.0.0')
