![CurseForge Downloads](https://img.shields.io/curseforge/dt/932306)

# UtilitiesPlus Addon

**UtilitiesPlus** is a lightweight Quality of Life addon for *World of Warcraft* designed to enhance your gaming experience. It provides various utility commands aimed at simplifying common tasks and boosting gameplay efficiency.

## Features

1. **Waypoints using Blizzard's Pin System**
   - Utilize the `/way` command to create map pins at specific coordinates.
   - Supports waypoint queues and automatic removal of pins upon reaching them.

2. **Clear Action Bars Command**
   - Use the `/clearbars` command to quickly wipe your action bars clean, allowing for easy reassignment of spells and items.

3. **Clear Quests Command**
   - Use the `/clearquests` command to remove all quests from your quest log.

4. **Prevent Automatic Adding of Spells**
   - An option to prevent spells from being automatically added to your action bars.

5. **Increased Equipment Set Limit**
   - Extends the equipment set limit from the default of 8 to a robust 100 sets.

6. **Minimap Socials Display** ✅ **(New!)**
   - Adds customizable text displays near the minimap showing the number of **Guild** and **Friends** (WoW + Battle.net) online.
   - Hovering over the display shows detailed tooltips:
     - **Guild**: Shows character names (without realm) and their zones, color-coded by class.
     - **Friends**: Shows **currently logged in characters** from WoW friends and Battle.net (WoW only), also with class-colored names and zones.
   - Click behavior:
     - Left-click: Opens a whisper to the selected name.
     - Right-click: Sends a party invite.
   - Fully configurable in font, size, alignment, color, and positioning.

---

## Usage

Once UtilitiesPlus is installed, you can start using its utility commands. Below is a list of commands:

### `/up` Command
Opens the configuration options for UtilitiesPlus.

### `/up help` Command
Lists all available commands.

### `/way` Command
Create a waypoint at the specified coordinates or add one to the queue if a waypoint is already active. The coordinates `x` and `y` are numbers that range from 0 to 100 and can include a decimal place. The map ID can optionally be provided prefixed with a `#` character.

Examples:
- `/way 36.6, 71.6`
- `/way 36.6 71.6`
- `/way 36 71`
- `/way #1 25, 25`
- `/way #1 25 25`
- `/way #1 25.0 25.0`

### `/way clear` Command
Clears the current active waypoint.

### `/way clear all` Command
Clears all waypoints from the queue as well as the active waypoint.

### `/clearbars` Command
Clears all spells and items from your action bars.

### `/clearquests` Command
Clears all quests in the quest log.
