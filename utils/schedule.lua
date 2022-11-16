-- Authors: Algoholics (Chase Villarroel,
--                      Sayaka Aliyah Hernandez,
--                      Shane Crisvy Ricafort)
-- Date: November 16, 2022
--
-- Description:
--     Contains the schedule class definition.
--     Implemented as an array of linked lists. See paper for more details
--     not included here.
--
-- References:
--   * Lua Documentation (https://www.lua.org/manual/5.4/)

-- Import modules
local LinkedList = require("dlist")
local Event = require("event")

-- Initialize base class
local Schedule = {}

-- Schedule class constructor.
function Schedule:new(raw_sched, mode)
  -- error handling
  if raw_sched == nil then
    error("Missing args for instantiating schedule queue")
  end

  -- create empty object
  local o = {}
  -- give it the methods defined here
  setmetatable(o, self)
  -- define object's self
  self.__index = self

  -- object attributes and initialization
  o.thresholds = LinkedList:new()

  -- set to repeating schedule by default
  mode = mode or "schedule"

  -- set array size based on schedule type
  if mode == "schedule" then
    o.cols = 7
  elseif mode == "reminders" then
    o.cols = 1
  else
    error("Invalid schedule mode.")
  end

  -- initialize object based on schedule type
  if o.cols == 7 then
    -- if repeating schedule, do fancy schedule manipulating
    o:init_sched(raw_sched)
    o:remove_empty()
    o:merge_dupes()
    -- force new day in program flow
    o.day = 0
  elseif o.cols == 1 then
    -- if nonrepeating schedule, no need to process and force new day
    o:init_sched(raw_sched)
    o.day = 1
  end

  -- initialize thresholds
  o:init_thresholds(raw_sched)

  return o
end

-- Converts the 2d table into an array of lists.
-- Args:
--     raw (2D array of str): Parsed schedule spreadsheet.
function Schedule:init_sched(raw)
  -- for each day...
  for day = 1, self.cols, 1 do
    -- create new linked list
    self[day] = LinkedList:new()
    -- fill with data
    for row = 2, #raw, 1 do
      local label = raw[row][day + 2]
      local start_time = raw[row][1]
      local end_time = raw[row][2]
      self[day]:append(Event:new(label, start_time, end_time))
    end
  end
end

-- Adds the starts and ends into a collection to limit display updating.
-- Args:
--     raw (2D array of str): Parsed schedule spreadsheet.
function Schedule:init_thresholds(raw)
  -- temporary array for sorting
  local thresholds = {}
  -- hash table for unique filtering
  local threshold_filter = {}

  -- hash map filtering
  -- add contents to hash map
  for row = 2, #raw, 1 do
    local start_time = raw[row][1]
    local end_time = raw[row][2]
    threshold_filter[start_time] = true
    threshold_filter[end_time] = true
  end
  -- get keys and add to tempory array
  for key, _ in pairs(threshold_filter) do
    table.insert(thresholds, key)
  end
  -- sort temporary array (implemented within Lua as quick sort)
  table.sort(thresholds)

  -- first and last thresholds for updating display
  local first, last
  if self.cols == 7 then
    -- if repeating schedule
    first = "00:00"
    last = "24:00"
  else
    -- if not repeating schedule
    first = "0000-00-00 00:00"
    last = "9999-12-31 24:00"
  end

  -- transfer contents to linked list
  self.thresholds:append(first)
  -- for every threshold...
  for _, val in ipairs(thresholds) do
    -- add to linked list
    self.thresholds:append(val)
  end
  self.thresholds:append(last)
end

-- Removes events with blank labels.
function Schedule:remove_empty()
  -- for each day...
  for day = 1, self.cols, 1 do
    self:set_day(day)
    local length = #self

    -- for each event...
    for _ = 1, length, 1 do
      local here = self:peek()
      if here.label == "" then
        -- if value at pointer is empty, remove
        self:remove()
      else
        -- if not empty, move to next event
        self:iterate()
      end
    end

    -- reset pointer once done
    self:reset()
  end
end

-- Merges adjacent events with identical labels.
function Schedule:merge_dupes()
  -- for each day...
  for day = 1, self.cols, 1 do
    self:set_day(day)
    local length = #self
    -- initialize previous
    local prev = self:peek()

    for _ = 2, length, 1 do
      -- next event
      self:iterate()
      local here = self:peek()

      -- if prev and next have the same label, and start and end times align,
      -- take next's end time and remove next
      if (prev.label == here.label
          and prev.end_time == here.start_time) then
        prev.end_time = here.end_time
        self:remove()
      else
        -- else, make this the previous event for the next iteration
        prev = here
      end
    end

    -- reset pointer once done
    self:reset()
  end
end

-- setters and wrappers
-- since linked lists are in an array, just select which linked list
function Schedule:set_day(day)
  self.day = day
  self:reset()
  self.thresholds:reset()
end

-- and run the method for the currently selected linked list
-- see linked list definition for more details
function Schedule:peek()
  return self[self.day]:peek()
end

function Schedule:iterate()
  return self[self.day]:iterate()
end

function Schedule:reset()
  return self[self.day]:reset()
end

function Schedule:remove()
  return self[self.day]:remove()
end

function Schedule:__len()
  return self[self.day].len
end

-- Iterator function for working with Lua's for loops.
function Schedule:iterator()
  local i = 1
  local n = #self
  self:reset()

  return function()
    while i <= n do
      i = i + 1
      return self:iterate()
    end
    self:reset()
  end
end

-- Override metamethod for easier printing.
-- Converts the collection into a string for debugging purposes.
function Schedule:__tostring()
  -- if empty, return empty string
  if #self == 0 then
    return ""
  end

  -- separator for pretty output
  local sep = " | "
  -- final string
  local stringed = sep

  -- for each event in today's schedule...
  for event in self:iterator() do
    -- print event an separator
    stringed = stringed .. tostring(event)
    stringed = stringed .. sep
  end

  -- return final string
  return stringed
end

return Schedule
