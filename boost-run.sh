#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLARITY_SINK="boost_clarity"
STATE_FILE="$HOME/.cache/boost_pre_clarity_sink"

_cleanup() {
    pactl list modules short 2>/dev/null | awk '$2=="module-ladspa-sink" && /sink_name='"$CLARITY_SINK"'/ {print $1}' \
        | xargs -r -I{} pactl unload-module {}
    if [ -f "$STATE_FILE" ]; then
        pactl set-default-sink "$(cat "$STATE_FILE")" 2>/dev/null
        rm -f "$STATE_FILE"
    fi
}

trap _cleanup EXIT
python3 "$SCRIPT_DIR/boost"
