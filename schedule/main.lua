-- Authors: Algoholics (Chase Villarroel,
--                      Sayaka Aliyah Hernandez,
--                      Shane Crisvy Ricafort)
-- Date: November 16, 2022
--
-- Description:
--     Visualizes the schedule in the given spreadsheet.
--     See readme (preferrably on GitHub) for demo images:
--       https://github.com/chusecubr/desalgo-finals
--     See final product vision at:
--       https://github.com/chusecubr/rm-docket
--
-- References:
--   * Lua Documentation (https://www.lua.org/manual/5.4/)

-- Importing modules
package.path = "../?.lua;../utils/?.lua;" .. package.path
local parser = require("parser")
local SKIN = require("settings"):new()
local Schedule = require("schedule")

-- Make schedule object global within this file.
-- Schedule object is an array containing linked lists for each day's events.
local sched

-- Temporarily stops execution.
-- Exclusive to Windows (makes a system call).
-- Args:
--     t (int): Time in seconds to stop code execution.
local function sleep(t)
  local n = t or 1
  os.execute("ping -n " .. tonumber(n + 1) .. " localhost > NUL")
end

-- Prints events with formatting and colored highlighting
local function display_sched(now)
  print("Schedule for the day")
  print("-----------------------\n")
  -- for each event...
  for event in sched:iterator() do
    -- get its color (based on its status)
    local color = SKIN:GetVariable(event:get_status(now), "\27[0m")
    -- change its color, print its label and time
    print(color .. event.label)
    print(event.start_time .. "-" .. event.end_time)
    -- reset color
    print("\27[0m")
  end
  print("-----------------------")
  print("Press `CTRL+C` to exit.")
end

-- Function that is run once upon program start
function Initialize()
  -- get file path and separator from settings
  local file_path = SKIN:GetVariable("Path", "schedule.csv")
  local delim = SKIN:GetVariable("Delimiter", ",")
  -- parse spreadsheet and create schedule object
  local sched_table = parser.parse_csv(file_path, delim)
  sched = Schedule:new(sched_table)
end

-- Function that is continuously run every interval.
function Update()
  -- get current times
  local now = os.date("%H:%M")
  local today

  -- set today based on ISO week setting
  if SKIN:GetVariable("ISOWeek", true) then
    today = os.date("%w") + 1
  else
    today = ((os.date("%w") + 5) % 6) + 1
  end

  -- if new day, set schedule to new day
  if today ~= sched.day then
    sched:set_day(today)
  end

  -- only update display when we've crossed a start/end time
  while now >= sched.thresholds:peek() do
    -- clear screen
    os.execute("cls")
    -- move to next threshold
    sched.thresholds:iterate()
    -- update display
    display_sched(now)
  end
end

-- Program loop
local function main()
  Initialize()
  while true do
    Update()
    sleep()
  end
end

main()
