-- Dummy SKIN object for testing without Rainmeter.
local Dummy = {}

function Dummy:new()
  local o = {}
  setmetatable(o, self)
  self.__index = self
  o.variables = {
    ["Delimiter"] = ",",
    ["Path"] = "schedule.csv",
    ["ISOWeek"] = "true",
    ["Upcoming"] = "\27[0m",
    ["Ongoing"] = "\27[32m",
    ["Completed"] = "\27[31m",
  }
  return o
end

function Dummy:GetVariable(var_name, default)
  return self.variables[var_name] or default or nil
end

return Dummy
