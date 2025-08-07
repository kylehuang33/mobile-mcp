#!/bin/bash

# ===================================================================
# DYNAMIC CALENDAR EVENT CREATOR FOR PIXEL 8 PRO
#
# This script accepts three arguments:
# $1: Event Name (String)
# $2: Start Delay (Integer, in minutes from now)
# $3: Duration (Integer, in minutes)
# ===================================================================

# --- 1. CONFIGURATION: PIXEL 8 PRO COORDINATES ---
# !! IMPORTANT !!
# Calibrate these coordinates using the "Pointer location" developer option on YOUR phone.
SAVE_BUTTON_X=880
SAVE_BUTTON_Y=180

# --- 2. READ ARGUMENTS WITH DEFAULTS ---
# This makes the script robust. If an argument isn't passed, it uses a default.
EVENT_NAME="${1:-Default Event from Script}"
START_DELAY_MIN="${2:-0}"
DURATION_MIN="${3:-60}"

echo ">> Preparing Event..."
echo "   - Title: $EVENT_NAME"
echo "   - Starting in: $START_DELAY_MIN minute(s)"
echo "   - Duration: $DURATION_MIN minute(s)"

# --- 3. CALCULATE TIMESTAMPS ---
# This section calculates the start and end times in milliseconds since the epoch.

# Note: The 'date' command syntax differs between macOS/BSD and Linux.
if [[ "$(uname)" == "Darwin" ]]; then
  # macOS syntax
  START_SECONDS=$(date -v+${START_DELAY_MIN}M +%s)
else
  # Linux syntax
  START_SECONDS=$(date -d "+${START_DELAY_MIN} minutes" +%s)
fi

# Convert duration to seconds
DURATION_SECONDS=$((DURATION_MIN * 60))

# Calculate end time in seconds
END_SECONDS=$((START_SECONDS + DURATION_SECONDS))

# Convert to milliseconds for the Android Intent
START_TIME_MS="${START_SECONDS}000"
END_TIME_MS="${END_SECONDS}000"

echo "   - Calculated Start (ms): $START_TIME_MS"
echo "   - Calculated End (ms): $END_TIME_MS"

# --- 4. EXECUTE ADB COMMANDS ---

echo ">> STEP 1: Opening Google Calendar..."
adb shell am start -a android.intent.action.INSERT \
    -t vnd.android.cursor.item/event \
    -p com.google.android.calendar \
    --es title "$EVENT_NAME" \
    --el beginTime "$START_TIME_MS" \
    --el endTime "$END_TIME_MS"

echo ">> STEP 2: Waiting 4 seconds for app to load..."
sleep 4

echo ">> STEP 3: Tapping 'Save' at (X:$SAVE_BUTTON_X, Y:$SAVE_BUTTON_Y)..."
adb shell input tap "$SAVE_BUTTON_X" "$SAVE_BUTTON_Y"

echo ">> SCRIPT COMPLETE."
