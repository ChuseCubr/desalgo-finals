local Queue = require("queue")
local Event = {}
local Schedule = Queue:new()

-- Event class constructor.
-- Contains event details (start and end).
function Event:new(label, start_time, end_time)
  local o = {}
  setmetatable(o, self)
  self.__index = self
  o.label = label
  o.start_time = start_time
  o.end_time = end_time
  return o
end

-- Returns whether the given time is upcoming, ongoing, or completed.
-- Used for dynamic styles.
function Event:get_status(time)
  if time < self.start_time then
    return "upcoming"
  end
  if time < self.end_time then
    return "ongoing"
  end
  return "completed"
end

-- Schedule class constructor.
-- Queue containing the day's events in order.
function Schedule:new(raw_sched, day)
  if raw_sched == nil or day == nil then
    error("Missing args for instantiating schedule queue")
  end

  local o = Queue:new()
  setmetatable(o, self)
  self.__index = self

  o.thresholds = {}
  local threshold_filter = {}

  day = day + 2
  for row = 2, #raw_sched, 1 do
    local label = raw_sched[row][day]
    local start_time = raw_sched[row][1]
    local end_time = raw_sched[row][2]
    o:enqueue(Event:new(label, start_time, end_time))
    threshold_filter[start_time] = true
    threshold_filter[end_time] = true
  end

  for key, _ in pairs(threshold_filter) do
    table.insert(o.thresholds, key)
  end

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
    local here = self:dequeue()
    if here.label ~= "" then
      self:enqueue(here)
    end
  end
end

-- Merges adjacent events with identical labels.
function Schedule:merge_dupes()
  local length = self.len
  if length == 0 then
    return
  end

  local prev = self:dequeue()
  local here

  for _ = 1, length, 1 do
    here = self:dequeue()
    if (prev.label ~= here.label
        or prev.end_time ~= here.start_time) then
      self:enqueue(prev)
      prev = here
    else
      prev.end_time = here.end_time
    end
  end

  self:push(here)
end

-- Override metamethod for easier printing.
-- For debugging purposes.
function Schedule:__tostring()
  if self.head == nil then
    return nil
  end

  local stringed = ""
  local here = self.head

  while here ~= nil do
    stringed = stringed .. here.value.label .. "(" .. here.value.start_time .. "-" .. here.value.end_time .. ")"
    here = here.next
    if here ~= nil then
      stringed = stringed .. ", "
    end
  end

  return stringed
end

return Schedule
