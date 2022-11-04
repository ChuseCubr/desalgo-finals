local LinkedList = require("dlist")
local Event = require("event")
local Schedule = LinkedList:new()

-- Schedule class constructor.
-- Queue containing the day's events in order.
function Schedule:new(raw_sched, day)
  if raw_sched == nil then
    error("Missing args for instantiating schedule queue")
  end

  local o = LinkedList:new()
  -- local o = {}
  setmetatable(o, self)
  self.__index = self

  o.thresholds = {}

  o:init_sched(raw_sched, day)
  o:init_thresholds(raw_sched)
  o:remove_empty()
  o:merge_dupes()

  return o
end

-- Converts the 2d table into a table of lists
function Schedule:init_sched(raw, day)
  -- for day = 1, 7, 1 do
  --   self[day] = LinkedList:new()
  for row = 2, #raw, 1 do
    local label = raw[row][day + 2]
    local start_time = raw[row][1]
    local end_time = raw[row][2]
    -- self[day]:append(Event:new(label, start_time, end_time))
    self:append(Event:new(label, start_time, end_time))
  end
  -- end
end

function Schedule:init_thresholds(raw)
  local threshold_filter = {}
  for row = 2, #raw, 1 do
    local start_time = raw[row][1]
    local end_time = raw[row][2]
    threshold_filter[start_time] = true
    threshold_filter[end_time] = true
  end

  for key, _ in pairs(threshold_filter) do
    table.insert(self.thresholds, key)
  end
  table.sort(self.thresholds)
end

-- Removes events with blank labels.
function Schedule:remove_empty()
  -- for day = 1, 7, 1 do
  -- self:set_day(day)
  local length = self.len
  if length == 0 then
    return
  end

  for _ = 1, length, 1 do
    local here = self:peek()
    if here.label == "" then
      self:remove()
    else
      self:increment()
    end
  end

  self:reset()
  -- end
end

-- Merges adjacent events with identical labels.
function Schedule:merge_dupes()
  -- for day = 1, 7, 1 do
  -- self:set_day(day)
  local length = self.len
  if length == 0 then
    return
  end

  local prev = self:peek()

  for _ = 2, length, 1 do
    local here = self:increment()
    if (prev.label == here.label
        and prev.end_time == here.start_time) then
      -- uses pointers behind the scenes,
      -- so this will change what's in the list
      prev.end_time = here.end_time
      self:remove()
    else
      prev = here
    end
  end

  self:reset()
  -- end
end

-- function Schedule:set_day(day)
--   self.day = day
-- end

-- function Schedule:peek()
--   return self[self.day]:peek()
-- end

-- function Schedule:increment()
--   return self[self.day]:increment()
-- end

-- function Schedule:reset()
--   return self[self.day]:reset()
-- end

function Schedule:__len()
  return self.len
end

-- Override metamethod for easier printing.
-- For debugging purposes.
function Schedule:__tostring()
  if self.len == 0 then
    return ""
  end

  local stringed = tostring(self:peek())

  for _ = 2, self.len, 1 do
    stringed = stringed .. ", "
    stringed = stringed .. tostring(self:increment())
  end

  return stringed
end

return Schedule
