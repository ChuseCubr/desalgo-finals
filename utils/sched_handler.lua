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
  day = day + 2
  local o = Queue:new()
  setmetatable(o, self)
  self.__index = self

  if raw_sched == nil or day == nil then
    error("Missing args for instantiating schedule queue")
  end
  for row = 2, #raw_sched, 1 do
    o:enqueue(Event:new(
      raw_sched[row][day],
      raw_sched[row][1],
      raw_sched[row][2]
    ))
    table.insert(o.thresholds, raw_sched[row][1])
  end
  table.insert(o.thresholds, raw_sched[#raw_sched][2])

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
