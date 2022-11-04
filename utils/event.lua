local Event = {}

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
    return "Upcoming"
  end
  if time < self.end_time then
    return "Ongoing"
  end
  return "Completed"
end

-- Override metamethod for easier printing.
-- For debugging purposes.
function Event:__tostring()
  return self.label .. " (" .. self.start_time .. "-" .. self.end_time .. ")"
end

return Event
