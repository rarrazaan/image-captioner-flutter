import os
from PIL import Image
import io
from flask import Flask, Blueprint, request, render_template, jsonify, Response, send_file
from googletrans import Translator
import numpy as np
import json
import base64
import generate_caption_transformer as gc

app = Flask(__name__)
static_dir = 'images/'


@app.route('/api', methods=['GET', 'POST'])
def apiHome():
    r = request.method
    if (r == "GET"):
        with open("text/data.json") as f:
            data = json.load(f)
        return data
    elif (r == 'POST'):
        with open(static_dir+'sample.jpg', "wb") as fh:
            fh.write(base64.decodebytes(request.data))
        captions = gc.generate_captions(static_dir+'sample.jpg')
        cap = {
            "captions_en": captions,
            "captions_id": Translator().translate(captions, dest='id').text,
        }
        with open("text/data.json", "w") as fjson:
            json.dump(cap, fjson)
        with open("text/data.json") as f:
            data = json.load(f)
        return data
    else:
        return jsonify({
            "captions_en": "Refresh again !",
            "captions_id": "Refresh again !"
        })


@app.route('/result')
def sendImage():
    return send_file(static_dir+'sample.jpg', mimetype='image/gif')


if __name__ == '__main__':
    app.run()
