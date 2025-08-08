#!/usr/bin/env bash
set -euo pipefail

# ====== CONFIG ======
# Join all arguments into one string, then escape spaces with backslash
QUERY_ESCAPED=$(printf "%s" "$*" | sed 's/ /\\ /g')

FIRST_TAP_X="${FIRST_TAP_X:-500}"    # Override via env if needed
FIRST_TAP_Y="${FIRST_TAP_Y:-650}"

# ====== STEP 1: Open YouTube app ======
adb shell am start -a android.intent.action.MAIN -c android.intent.category.LAUNCHER -n com.google.android.youtube/.HomeActivity \
  || adb shell monkey -p com.google.android.youtube -c android.intent.category.LAUNCHER 1
sleep 2

# ====== STEP 2: Open search and type query ======
adb shell input keyevent 84                 # KEYCODE_SEARCH
sleep 1
adb shell input text "$QUERY_ESCAPED"       # Type with escaped spaces
adb shell input keyevent 66                 # ENTER
sleep 2                                     # Wait for results

# ====== STEP 3: Click the first result ======
adb shell input tap "$FIRST_TAP_X" "$FIRST_TAP_Y"

sleep 3

adb shell monkey -p com.example.local_llm -c android.intent.category.LAUNCHER 1
