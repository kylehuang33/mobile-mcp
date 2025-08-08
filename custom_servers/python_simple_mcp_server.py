import json
import asyncio
from typing import List
from fastmcp import FastMCP
from datetime import datetime, timedelta
import subprocess

async def _create_calendar_event(title: str, start_time: str, duration_minutes: int) -> str:
    """
    Internal logic to create and save a calendar event using a bash script.
    """
    try:
        dt = datetime.fromisoformat(start_time)
        unix_seconds = int(dt.timestamp())

        command = [
            "bash",
            "./scripts/create_event.sh",  # Replace with full path if needed
            title,
            str(unix_seconds),
            str(duration_minutes)
        ]

        output = subprocess.check_output(command, stderr=subprocess.STDOUT).decode("utf-8")
        return f"✅ Event created:\n{output}"
    except Exception as e:
        return f"❌ Failed to create event: {e}"


mcp = FastMCP("adb_server", host="0.0.0.0")

@mcp.tool()
async def create_calendar_event(
    title: str,
    start_time: str,
    duration_minutes: int
) -> str:
    """
    Create and save a calendar event. This function is timezone-aware
    and assumes the input start_time is for the system's local timezone.

    Args:
        title: Event title.
        start_time: ISO format string (e.g., "2025-08-07T18:30:00").
        duration_minutes: Event duration in minutes.

    Returns:
        A success or failure message including the output from the shell script.
    """
    try:
        # Convert ISO time string to UNIX timestamp in seconds
        dt = datetime.fromisoformat(start_time)
        unix_seconds = int(dt.timestamp())  # This works on both Linux and macOS

        command = [
            "bash",
            "./scripts/create_event.sh",  # Replace with full path if needed
            title,
            str(unix_seconds),
            str(duration_minutes)
        ]
        output = subprocess.check_output(command, stderr=subprocess.STDOUT).decode("utf-8")
        return f"Event created successfully:\n{output}"
    except subprocess.CalledProcessError as e:
        return f"Failed to create event:\n{e.output.decode('utf-8')}"


def testing():

    # Test values
    test_title = "Test Meeting from Python"
    test_start_time = "2025-08-07T20:30:00"
    test_duration = 30

    print(">> Testing create_calendar_event locally...\n")

    result = asyncio.run(
        _create_calendar_event(
            title=test_title,
            start_time=test_start_time,
            duration_minutes=test_duration
        )
    )

    print(result)


if __name__ == "__main__":
    mcp.run(
        transport="sse", 
        host="localhost",
        port=6001,
        path=""
    )
    # testing()

