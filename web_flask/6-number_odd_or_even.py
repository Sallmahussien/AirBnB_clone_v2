#!/usr/bin/python3
"""Starts a Flask web application"""

from flask import Flask, render_template

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


@app.route("/python/", defaults={"username": ""}, strict_slashes=False)
@app.route("/python/<username>", strict_slashes=False)
def print_python_path(username):
    """Display Python Path"""
    if username == "":
        return "Python is cool"

    return "Python {}".format(username.replace("_", " "))


@app.route("/number/<int:n>", strict_slashes=False)
def print_integer(n):
    """Display number if it is integer"""
    return f"{n} is a number"


@app.route("/number_template/<int:n>", strict_slashes=False)
def render_number(n):
    return render_template("5-number.html", number=n)


@app.route("/number_odd_or_even/<int:n>", strict_slashes=False)
def number_odd_or_even(n):
    return render_template("6-number_odd_or_even.html", number=n)


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
