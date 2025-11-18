#!/bin/bash
# Wait for PulseAudio to start
sleep 3
# Load virtual ALSA DMIC into PulseAudio
pactl load-module module-alsa-source device=dmic source_name=internal_dmic channels=1
