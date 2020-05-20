#!/usr/bin/env python
""" U up? Check if a website is available. """

import requests

from flask import Flask, jsonify

app = Flask(__name__)


@app.route("/uup/<path:url>", methods=["GET"])
def u_up(url):
    """ Return url status code """
    if "https" not in url:
        url = "https://" + url
    try:
        resp = {"url": url, "status": requests.get(url).status_code}
    except requests.exceptions.SSLError:
        resp = None
    return jsonify(resp)


@app.route("/")
def hello_world():
    return "Hello, World!"


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0")
