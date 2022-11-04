package.path = "../utils/?.lua;" .. package.path
local parser = require("parser")
local SKIN = require("settings"):new()
local Schedule = require("sched_handler")
local sched

-- Change of plan. Rainmeter is weird, so might have to resort to having
-- a separate script do the file editing, and Rainmeter will just refresh.
-- There's too little time for drastic changes, so I'll settle on a
-- proof-of-concept CLI for now.

-- Temporarily stops execution.
local function sleep(t)
  local n = t or 1
  os.execute("ping -n " .. tonumber(n + 1) .. " localhost > NUL")
end

-- Fancily prints events.
local function display_sched(now)
  for event in sched:iterator() do
    local color = SKIN:GetVariable(event:get_status(now), "\27[0m")
    print(color .. event.label)
    print(event.start_time .. "-" .. event.end_time)
    print("\27[0m")
  end
  sched:reset()
  print("Press `CTRL+C` to exit.")
end

function Initialize()
  local file_path = SKIN:GetVariable("Path", "schedule.csv")
  local sched_table = parser.parse_csv(file_path)
  sched = Schedule:new(sched_table)
  os.execute("cls")
  display_sched(os.date("%H:%M"))
end

function Update()
  local today = os.date("%w") + 1
  local now = os.date("%H:%M")

  if today ~= sched.day then
    sched:set_day(today)
  end

  while now > sched.thresholds:peek() do
    os.execute("cls")
    sched.thresholds:iterate()
    sched:reset()
    display_sched(now)
  end
end

local function main()
  Initialize()
  while true do
    Update()
    sleep()
  end
end

main()
