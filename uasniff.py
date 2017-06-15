#!/usr/bin/env python

import flask

app = flask.Flask(__name__)

@app.route('/')
def home():
    user_agent = flask.request.user_agent
    return flask.render_template('index.html', user_agent=user_agent)

if __name__ == '__main__':
    app.run()
