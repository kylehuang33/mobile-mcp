#!/bin/bash

# ==============================================================
# DYNAMIC CALENDAR EVENT CREATOR FOR PIXEL 8 PRO (explicit time)
# ==============================================================

# --- CONFIG: Calibrated coordinates for Save button ---
SAVE_BUTTON_X=880
SAVE_BUTTON_Y=180

# --- READ ARGUMENTS ---
EVENT_NAME="${1:-Default Event from Script}"
START_UNIX_SECONDS="${2:-$(date +%s)}"
DURATION_MIN="${3:-60}"

echo "DEBUG: Raw \$1 = \"$1\""
echo "DEBUG: Parsed EVENT_NAME = \"$EVENT_NAME\""

echo ">> Preparing Event..."
echo "   - Title: $EVENT_NAME"
echo "   - Start Time (UNIX seconds): $START_UNIX_SECONDS"
echo "   - Duration: $DURATION_MIN minutes"

# --- CALCULATE TIMESTAMPS ---
DURATION_SECONDS=$((DURATION_MIN * 60))
END_UNIX_SECONDS=$((START_UNIX_SECONDS + DURATION_SECONDS))

START_TIME_MS="${START_UNIX_SECONDS}000"
END_TIME_MS="${END_UNIX_SECONDS}000"

# --- EXECUTE ADB COMMANDS ---
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

echo ">> DONE: Event created successfully."
