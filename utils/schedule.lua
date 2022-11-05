local LinkedList = require("dlist")
local Event = require("event")
local Schedule = LinkedList:new()

-- Schedule class constructor.
-- Queue containing the day's events in order.
function Schedule:new(raw_sched, mode)
  if raw_sched == nil then
    error("Missing args for instantiating schedule queue")
  end

  -- local o = LinkedList:new()
  local o = {}
  setmetatable(o, self)
  self.__index = self


  o.thresholds = LinkedList:new()

  mode = mode or "schedule"
  if mode == "schedule" then
    o.cols = 7
  elseif mode == "reminders" then
    o.cols = 1
  else
    error("Invalid schedule mode.")
  end

  o.mode = mode or "schedule"
  if o.mode == "schedule" then
    o:init_sched(raw_sched)
    o:remove_empty()
    o:merge_dupes()
    o.day = 0
  elseif o.mode == "reminders" then
    o:init_sched(raw_sched)
    o.day = 1
  end

  o:init_thresholds(raw_sched)

  return o
end

-- Converts the 2d table into a table of lists.
function Schedule:init_sched(raw)
  for day = 1, self.cols, 1 do
    self[day] = LinkedList:new()
    for row = 2, #raw, 1 do
      local label = raw[row][day + 2]
      local start_time = raw[row][1]
      local end_time = raw[row][2]
      self[day]:append(Event:new(label, start_time, end_time))
      -- self:append(Event:new(label, start_time, end_time))
    end
  end
end

-- Adds the starts and ends into a collection to limit checking.
function Schedule:init_thresholds(raw)
  local thresholds = {}
  local threshold_filter = {}
  for row = 2, #raw, 1 do
    local start_time = raw[row][1]
    local end_time = raw[row][2]
    threshold_filter[start_time] = true
    threshold_filter[end_time] = true
  end

  for key, _ in pairs(threshold_filter) do
    table.insert(thresholds, key)
  end
  table.sort(thresholds)

  local first, last
  if self.cols == 7 then
    first = "00:00"
    last = "24:00"
  else
    first = "0000-00-00 00:00"
    last = "9999-12-31 24:00"
  end
  self.thresholds:append(first)
  for _, val in ipairs(thresholds) do
    self.thresholds:append(val)
  end
  self.thresholds:append(last)
end

-- Removes events with blank labels.
function Schedule:remove_empty()
  for day = 1, self.cols, 1 do
    self:set_day(day)
    local length = #self

    for _ = 1, length, 1 do
      local here = self:peek()
      if here.label == "" then
        self:remove()
      else
        self:iterate()
      end
    end

    self:reset()
  end
end

-- Merges adjacent events with identical labels.
function Schedule:merge_dupes()
  for day = 1, self.cols, 1 do
    self:set_day(day)
    local length = #self
    local prev = self:peek()

    for _ = 2, length, 1 do
      self:iterate()
      local here = self:peek()

      if (prev.label == here.label
          and prev.end_time == here.start_time) then
        prev.end_time = here.end_time
        self:remove()
      else
        prev = here
      end
    end

    self:reset()
  end
end

-- setters and wrappers
function Schedule:set_day(day)
  self.day = day
  self:reset()
  self.thresholds:reset()
end

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
-- For debugging purposes.
function Schedule:__tostring()
  if #self == 0 then
    return ""
  end

  local stringed = " | "

  for event in self:iterator() do
    stringed = stringed .. tostring(event)
    stringed = stringed .. " | "
  end

  return stringed
end

return Schedule
