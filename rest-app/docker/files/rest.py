from flask import Flask, request, jsonify, make_response
from flask_cors import CORS, cross_origin

app = Flask(__name__)
CORS(app)

@app.route('/demo', methods=['GET'])
@cross_origin(headers=['Content-Type', 'application/json'])
def demo():
  return 200

@app.route('/ready', methods=['GET'])
@cross_origin(headers=['Content-Type', 'application/json'])
def ready():
  return 200

@app.route('/health', methods=['GET'])
@cross_origin(headers=['Content-Type', 'application/json'])
def health():
  return 200

if __name__== '__main__':
    app.run()


  