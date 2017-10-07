#!/usr/bin/env bash

# Photo organisation script, based of Peter Mckinnon's workflow
# (with a few changes) and automated

# Currently pretty slow as it runs exiftool on every image it processes

DRIVE="/Volumes/Photos"

while getopts ":n:i:d::m" opt; do
    case "$opt" in
        n) EVENT="${OPTARG}" ;;
        i) IN_DIR="${OPTARG}" ;;
        d) DRIVE="${OPTARG}" ;;
        m) MISC=true ;;
        *) usage ;;
    esac
done
shift $((OPTIND-1))

usage() {
    echo "Usage: mckinnonify.sh -n event_name -i directory [-m | -d output_base]"
    exit 1
}

if [ -z "$EVENT" ] || [ -z "$IN_DIR" ]; then
    usage
fi

for image in "$IN_DIR"*; do
    DTO="$(exiftool "$image" -DateTimeOriginal -s -s -s)"
    YEAR="${DTO/:*}"

    DATE="${DTO% *}"
    DATE="${DATE//:/-}"

    MODEL="$(exiftool "$image" -Model -s -s -s)"
    MODEL="${MODEL/Canon EOS }"

    TYPE="$(exiftool "$image" -FileType -s -s -s)"
    if [[ "$TYPE" == "DNG" ]] || [[ "$TYPE" == "CR2" ]]; then
        TYPE="RAW"
    else
        TYPE="Other"
    fi

    if [ "$MISC" ]; then
        BASE_DIR="$DRIVE/$YEAR/Miscellaneous $YEAR/$EVENT/$DATE/$MODEL/$TYPE/"
    else
        BASE_DIR="$DRIVE/$YEAR/$EVENT $YEAR/$DATE/$MODEL/$TYPE/"
    fi

    if [ ! -d "$BASE_DIR" ]; then
        echo "Cannot find $BASE_DIR"
        mkdir -pv "$BASE_DIR"
    fi

    cp -v "$image" "$BASE_DIR"

done
