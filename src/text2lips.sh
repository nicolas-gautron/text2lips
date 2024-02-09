#!/bin/bash

WAV2LIP="/vendor/Wav2Lip"
WORKSPACE="/home"
RESULTING_SPEECH="$WORKSPACE/results/resulting_speech.wav"
RESULTING_VIDEO="$WORKSPACE/results/resulting_video.mp4"

usage() {
    echo "Usage: $0 -t text.txt -v voice_sample_audio_or_video.mp4 -p photo_or_video.jpg -l en"
}

while getopts t:v:p:l:h flag
do
    case "${flag}" in
        t) textFile=${OPTARG};;
        v) voice=${OPTARG};;
        p) photo=${OPTARG};;
        l) language=${OPTARG};;
        h) usage; exit 0;;
    esac
done

if [ -z "$textFile" ] || [ -z "$voice" ] || [ -z "$photo" ] || [ -z "$language" ]; then
    usage
    exit 1
fi

echo -e "-------------------------------------\nRunning Text to Speech...\n-------------------------------------"
python3 /home/src/text_to_speech.py \
    --text_file $textFile \
    --voice $voice \
    --language $language \
    --output_path $RESULTING_SPEECH

if [ ! -f $RESULTING_SPEECH ]; then
    echo "Failed to generate the speech."
    exit 1
fi

echo -e "-------------------------------------\nRunning Lip sync...\n-------------------------------------"

cd $WAV2LIP

python3 $WAV2LIP/inference.py \
    --checkpoint_path $WAV2LIP/checkpoints/wav2lip.pth \
    --face $photo \
    --audio $RESULTING_SPEECH

cd -

if [ ! -f "$WAV2LIP/results/result_voice.mp4" ]; then
    echo "Failed to generate the video."
    exit 1
fi

cp $WAV2LIP/results/result_voice.mp4 $RESULTING_VIDEO

echo -e "-------------------------------------\nProcess completed successfully. The result is saved in $RESULTING_VIDEO\n-------------------------------------"
