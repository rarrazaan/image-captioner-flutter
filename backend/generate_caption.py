from pickle import load
from numpy import argmax
import argparse
import os
from gtts.tts import gTTS
from keras_preprocessing.sequence import pad_sequences
from keras.applications.vgg16 import VGG16
from tensorflow.keras.utils import load_img
from tensorflow.keras.utils import img_to_array
# from keras.applications.vgg16 import preprocess_input
from keras.models import Model
from keras.models import load_model
from keras.applications.xception import Xception #to get pre-trained model Xception
from keras.applications.xception import preprocess_input


def extract_features(filename):
    model = Xception(include_top=False, pooling="avg")
    model.layers.pop()
    model = Model(inputs=model.inputs, outputs=model.layers[-1].output)
    image = load_img(filename, target_size=(299, 299))
    image = img_to_array(image)
    image = image.reshape((1, image.shape[0], image.shape[1], image.shape[2]))
    image = preprocess_input(image)
    feature = model.predict(image, verbose=0)
    return feature


def word_for_id(integer, tokenizer):
    for word, index in tokenizer.word_index.items():
        if index == integer:
            return word
    return None


def generate_desc(model, tokenizer, photo, max_length):
    in_text = 'startseq'
    for i in range(max_length):
        sequence = tokenizer.texts_to_sequences([in_text])[0]
        sequence = pad_sequences([sequence], maxlen=max_length)
        yhat = model.predict([photo, sequence], verbose=0)
        yhat = argmax(yhat)
        word = word_for_id(yhat, tokenizer)
        if word is None:
            break
        in_text += ' ' + word
        if word == 'end':
            break
    return in_text


def generate_captions(photo_path):
    tokenizer = load(open('tokenizer.p', 'rb'))
    max_length = 32
    model = load_model('model.h5', compile=False)
    model.compile()
    photo = extract_features(photo_path)
    description = generate_desc(model, tokenizer, photo, max_length)
    description = description[9:-6]
    return description
