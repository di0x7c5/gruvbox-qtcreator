#!/bin/bash
#
# Generate SVG image base on palette file
# Copyright (C) 2023 by di0x7c5
#

declare -a SVG

function svg {
    SVG+=("$@")
}

function generate_svg {
    for L in "${SVG[@]}"; do echo "$L"; done
}

function hex2r {
    printf "%d" 0x${1:1:2}
}

function hex2g {
    printf "%d" 0x${1:3:2}
}

function hex2b {
    printf "%d" 0x${1:5:2}
}

function hex2l {
    printf "%d" $(echo "0.2126*$1 + 0.7152*$2 + 0.0722*$3" | bc | cut -d'.' -f1)
}

function svg_generate_watch {
    local X=$1
    local Y=$2
    local C=$3
    local T=$4
    local R=$(hex2r $C)
    local G=$(hex2g $C)
    local B=$(hex2b $C)
    local L=$(hex2l $R $G $B)

    # Use white font color on dark watchers
    if [ $L -lt 150 ]; then
        FONT_COLOR="#ffffff"
    else
        FONT_COLOR="#000000"
    fi

    svg "  <g transform='translate($((100 * $X)),$((75 * $Y)))'>"
    svg "    <rect x='0' y='0' width='100' height='75' fill='${C}' />"
    svg "    <rect x='0' y='70' width='100' height='5' fill='#000000' fill-opacity='0.25' />"
    svg "    <text x='50' y='42.7' font-size='18' fill='${FONT_COLOR}' text-anchor='middle'>${T}</text>"
    svg "    <text x='50' y='60' font-size='8' fill='${FONT_COLOR}' text-anchor='middle'>${C}</text>"
    svg "    <text x='5' y='12' font-size='8' fill='${FONT_COLOR}' text-anchor='start'>${R}</text>"
    svg "    <text x='50' y='12' font-size='8' fill='${FONT_COLOR}' text-anchor='middle'>${G}</text>"
    svg "    <text x='95' y='12' font-size='8' fill='${FONT_COLOR}' text-anchor='end'>${B}</text>"
    svg "  </g>"
}

svg "<?xml version='1.0' encoding='UTF-8' standalone='no'?>"
svg "<svg viewBox='0 0 800 300' xmlns='http://www.w3.org/2000/svg'>"

PALETTE_FILE_PATH=$1
X=0
Y=0

# Read all pin descriptions
while read LINE; do
    # Ommit empty lines
    [ -z "$LINE" ] && continue

    C=$(echo $LINE | cut -d' ' -f1)
    T=$(echo $LINE | cut -d' ' -f2)

    svg_generate_watch $X $Y $C $T
    X=$((X+1))

    if [ $X = 8 ]; then
        X=0
        Y=$((Y+1))
    fi
done < $PALETTE_FILE_PATH

svg "  <style>"
svg "    <![CDATA["
svg "      text {"
svg "        font-family: Roboto Condensed;"
svg "        fill-opacity: 0.70"
svg "      }"
svg "    ]]>"
svg "  </style>"
svg "</svg>"

generate_svg

# Happy finish
exit 0
