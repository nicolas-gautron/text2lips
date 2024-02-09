import argparse
from TTS.api import TTS

def read_text_from_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        return file.read()

parser = argparse.ArgumentParser(description="Generate an audio file based on a text and a record of the voice.")
parser.add_argument("--text_file", type=str, required=True, help="Path to the text.")
parser.add_argument("--output_path", type=str, required=True, help="Output audio file.")
parser.add_argument("--voice", type=str, required=True, help="Voice record.")
parser.add_argument("--language", type=str, required=True, help="E.g: en, fr...")

args = parser.parse_args()

text = read_text_from_file(args.text_file)

tts = TTS("tts_models/multilingual/multi-dataset/xtts_v2", gpu=False).to("cpu")

tts.tts_to_file(
    text=text,
    speaker_wav=args.voice,
    language=args.language,
    file_path=args.output_path
)

print(f"Audio generated and saved in {args.output_path}")
