# Text2Lips

Make your photo tell their best stories.

This project uses :

- [TTS](https://pypi.org/project/TTS/) to create the audio speech from a text and a voice sample.
- [Wav2Lip](https://github.com/justinjohn0306/Wav2Lip) to make the lips move on a photo.

&nbsp;
___

## Installation

&nbsp;
### Step 1

Download [this file](https://www.adrianbulat.com/downloads/python-fan/s3fd-619a316812.pth), rename it to `s3fd.pth` and place it in `assets/Wav2Lip`.

&nbsp;
### Step 2
Download these files and place them in `assets/Wav2Lip/checkpoints/` :

- [Wav2Lip](https://iiitaphyd-my.sharepoint.com/:u:/g/personal/radrabha_m_research_iiit_ac_in/Eb3LEzbfuKlJiR600lQWRxgBIY27JZg80f7V9jtMfbNDaQ?e=TBFBVW)
- [Wav2Lip + GAN](https://iiitaphyd-my.sharepoint.com/:u:/g/personal/radrabha_m_research_iiit_ac_in/EdjI7bZlgApMqsVoEUUXpLsBxqXbn5z8VTmoxp55YNDcIA?e=n9ljGW)
- [Expert Discriminator](https://iiitaphyd-my.sharepoint.com/:u:/g/personal/radrabha_m_research_iiit_ac_in/EQRvmiZg-HRAjvI6zqN9eTEBP74KefynCwPWVmF57l-AYA?e=ZRPHKP)
- [Visual Quality Discriminator](https://iiitaphyd-my.sharepoint.com/:u:/g/personal/radrabha_m_research_iiit_ac_in/EQVqH88dTm1HjlK11eNba5gBbn15WMS0B0EZbDBttqrqkg?e=ic0ljo)

&nbsp;

### Step 3
Create the Docker image (~22 GB) :
```
docker build -t text2lips .
```
&nbsp;

### Step 4
Create the container :
```
docker run -it --rm -v .:/home text2lips
```

&nbsp;
___

## Execution
&nbsp;

To run the whole process :
```
/home/src/text2lips.sh \
    -t /home/assets/sources/text.txt \
    -v /home/assets/sources/voice_sample_audio_or_video.mp4 \
    -p /home/assets/sources/photo_or_video.jpg \
    -l en
```

&nbsp;

To run only the text to speech :
```
python3 /home/src/text_to_speech.py \
    --text_file /home/assets/sources/text.txt \
    --voice /home/assets/sources/voice_sample_audio_or_video.mp4 \
    --language en \
    --output_path /home/results/resulting_speech.wav
```

&nbsp;

To run only the audio to lip sync :
```
cd /vendor/Wav2Lip

python3 /vendor/Wav2Lip/inference.py \
    --checkpoint_path /vendor/Wav2Lip/checkpoints/wav2lip.pth \
    --face /home/assets/sources/photo_or_video.jpg \
    --audio /home/results/resulting_speech.wav
```

The result will be in `/vendor/Wav2Lip/results/result_voice.mp4`.
