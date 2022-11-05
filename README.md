# DESALGO Final Project

A reimplementation of my project [Docket](https://github.com/ChuseCubr/RM-Docket) with more appropriate data structures and algorithms.

![Schedule Example](https://user-images.githubusercontent.com/27886422/200131964-a28e824c-ad10-4923-b262-e8b768db7577.png)

![Reminders Example](https://user-images.githubusercontent.com/27886422/200131966-55a1dab1-d7ca-40e8-baea-22768801b662.png)

## Table of Contents

* [Dependencies](#dependencies)
* [Installation](#installation)
* [Configuration](#configuration)
  * [Status Colors](#status-colors)
* [Important Note](#important-note)

## Dependencies

Unlike the original, this is just a proof-of-concept/prototype. It's only a CLI, so no need for Rainmeter. A Lua binary is provided.

## Installation

Download the source code with the green button above and extract the zip file.

Edit `schedule\schedule.csv` and `reminders\reminders.csv` to your needs. By default, it's read as ISO weeks (Sunday first day of the week). To change this, please see the [configuration section](https://github.com/ChuseCubr/desalgo-finals#configuration). 

## Configuration

To configure the available settings, edit the `settings.lua` file.

```lua
-- settings.lua

-- configure your settings here
o.variables = {
  -- csv file names
  ["SchedulePath"] = "schedule.csv",
  ["RemindersPath"] = "reminders.csv",

  -- csv delimiter based on your locale (most use `,`)
  ["Delimiter"] = ",",

  -- sunday first day of the week
  ["ISOWeek"] = true,

  -- status colors
  -- change the number after the [
  -- for reference: https://en.wikipedia.org/wiki/ANSI_escape_code#3-bit_and_4-bit
  ["Upcoming"] = "\27[0m",
  ["Ongoing"] = "\27[32m",
  ["Completed"] = "\27[31m",
}
```

### Status Colors

To change status colors, check out [ANSI escape sequences](https://en.wikipedia.org/wiki/ANSI_escape_code#3-bit_and_4-bit).

For example:

```lua
-- sets the ongoing status color to bright cyan
["Ongoing"] = "\27[96m",
```

## Important Note

If you exit the program incorrectly (not pressing `CTRL+C`), you well get an error popup that won't go away:

![image](https://user-images.githubusercontent.com/27886422/200134864-03dd8d81-ddee-4bd8-898b-4d5f96ad73c2.png)

You'll have to kill it with task manager:

* `CTRL+SHIFT+ESC` or `CTRL+ALT+DEL > Task Manager`
* Look for `Lua Console Standalone Interpreter` and select it
* Click `End task`

![image](https://user-images.githubusercontent.com/27886422/200134992-63f6cf33-29d9-4461-8a8d-b35871280686.png)
