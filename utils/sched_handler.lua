local LinkedList = require("dlist")
local Event = require("event")
local Schedule = LinkedList:new()

-- Schedule class constructor.
-- Queue containing the day's events in order.
function Schedule:new(raw_sched, day)
  if raw_sched == nil or day == nil then
    error("Missing args for instantiating schedule queue")
  end

  local o = LinkedList:new()
  setmetatable(o, self)
  self.__index = self

  o.thresholds = {}
  local threshold_filter = {}

  day = day + 2
  for row = 2, #raw_sched, 1 do
    local label = raw_sched[row][day]
    local start_time = raw_sched[row][1]
    local end_time = raw_sched[row][2]
    o:append(Event:new(label, start_time, end_time))
    threshold_filter[start_time] = true
    threshold_filter[end_time] = true
  end

  for key, _ in pairs(threshold_filter) do
    table.insert(o.thresholds, key)
  end
  table.sort(o.thresholds)

  o:remove_empty()
  o:merge_dupes()

  return o
end

-- Removes events with blank labels.
function Schedule:remove_empty()
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
end

-- Merges adjacent events with identical labels.
function Schedule:merge_dupes()
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
      -- so this will change what's in the queue
      prev.end_time = here.end_time
      self:remove()
    else
      prev = here
    end
  end

  self:reset()
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
