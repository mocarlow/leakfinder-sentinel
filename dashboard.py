#!/usr/bin/env python3
"""
Dashboard for LeakFinder Sentinel v1 - Ghost Edition
Run with: python3 dashboard.py

Tested on Python 3.8.
"""

from flask import Flask, render_template_string
import os
from datetime import datetime

app = Flask(__name__)
LOG_DIR = "logs"

if not os.path.exists(LOG_DIR):
    os.makedirs(LOG_DIR)

@app.route('/')
def index():
    logs = []
    for filename in sorted(os.listdir(LOG_DIR), reverse=True):
        if filename.endswith(".log") or filename.endswith(".md") or filename.endswith(".log.enc"):
            filepath = os.path.join(LOG_DIR, filename)
            try:
                with open(filepath, 'r') as f:
                    content = f.read()
            except Exception as e:
                content = f"Error reading file: {e}"
            logs.append({
                "filename": filename,
                "content": content,
                "timestamp": datetime.fromtimestamp(os.path.getmtime(filepath)).strftime("%Y-%m-%d %H:%M:%S")
            })
    template = """
    <!doctype html>
    <html>
      <head>
        <title>LeakFinder Sentinel Dashboard</title>
        <style>
          body { font-family: Arial, sans-serif; background: #121212; color: #f0f0f0; padding:20px; }
          .log { border: 1px solid #444; margin: 10px; padding: 10px; border-radius: 5px; }
          h1 { text-align: center; }
          pre { white-space: pre-wrap; word-wrap: break-word; }
        </style>
      </head>
      <body>
        <h1>LeakFinder Sentinel Dashboard</h1>
        {% for log in logs %}
          <div class="log">
            <h3>{{ log.filename }} - {{ log.timestamp }}</h3>
            <pre>{{ log.content }}</pre>
          </div>
        {% endfor %}
      </body>
    </html>
    """
    return render_template_string(template, logs=logs)

if __name__ == '__main__':
    app.run(host="127.0.0.1", port=6969, debug=True)
