#!/bin/bash

function has_substring() {
   [[ "$1" =~ $2 ]]
}

commit="$1"

if has_substring "$commit" "bump::major"; then
	bump=major

elif has_substring "$commit" "bump::minor"; then
	bump=minor

elif has_substring "$commit" "bump::patch"; then
	bump=patch

else
	bump=none
fi

echo "Bump: $bump"

echo "::set-output name=bump::$bump"