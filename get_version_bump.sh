#!/bin/bash

function has_substring() {
   [[ "$1" =~ $2 ]]
}

text="$1"

if has_substring "$text" "bump::major"; then
	bump=major

elif has_substring "$text" "bump::minor"; then
	bump=minor

elif has_substring "$text" "bump::patch"; then
	bump=patch
fi

echo "$bump"