from pickle import load
from numpy import argmax
import argparse
import os
from transformers import pipeline


def generate_captions(photo_path):

    image_to_text = pipeline(
        "image-to-text", model="vit-gpt2-image-captioning")

    description = image_to_text(photo_path)[0]["generated_text"]

    # [{'generated_text': 'a soccer game with a player jumping to catch the ball '}]

    return description
