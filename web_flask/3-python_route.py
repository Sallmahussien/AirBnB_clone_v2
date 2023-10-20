#!/usr/bin/python3
"""Starts a Flask web application"""

from flask import Flask

app = Flask(__name__)


@app.route("/", strict_slashes=False)
def home():
    """Display some text"""
    return "Hello HBNB!"


@app.route("/hbnb", strict_slashes=False)
def hbnb():
    """Display hbnb"""
    return "HBNB"


@app.route("/c/<username>", strict_slashes=False)
def print_c_path(username):
    """Display C Path"""
    return "C {}".format(username.replace("_", " "))


@app.route("/python/", defaults={"text": ""}, strict_slashes=False)
@app.route("/python/<text>", strict_slashes=False)
def print_python_path(text):
    """Display Python Path"""
    if text == "":
        return "Python is cool"

    return "Python {}".format(text.replace("_", " "))


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
