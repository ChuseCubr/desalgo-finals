-- Authors: Algoholics (Chase Villarroel,
--                      Sayaka Aliyah Hernandez,
--                      Shane Crisvy Ricafort)
-- Date: November 16, 2022
--
-- Description:
--     Contains event class definition.
--     Data class to hold event details and evaluate event status.
--
-- References:
--   * Lua Documentation (https://www.lua.org/manual/5.4/)

-- Initialize base class
local Event = {}

-- Event class constructor.
-- Contains event details (start and end).
-- Args:
--     label (str): Event label.
--     start_time (str): Event starting time.
--     end_time (str): Event ending time
function Event:new(label, start_time, end_time)
  -- create empty object
  local o = {}
  -- give it the methods defined here
  setmetatable(o, self)
  -- define object's self
  self.__index = self
  -- object attributes
  o.label = label
  o.start_time = start_time
  o.end_time = end_time
  return o
end

-- Returns whether the event is upcoming, ongoing, or completed
-- based on the given time. Used for dynamic styles.
function Event:get_status(time)
  if time < self.start_time then
    -- if given time is before start time
    return "Upcoming"
  end
  if time < self.end_time then
    -- if given time is after start time, but before end time
    return "Ongoing"
  end
  -- if after end time
  return "Completed"
end

-- Override metamethod for easier printing.
-- Converts object to string for debugging purposes.
function Event:__tostring()
  return self.label .. " (" .. self.start_time .. "-" .. self.end_time .. ")"
end

return Event
