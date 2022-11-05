-- Dummy SKIN object for testing without Rainmeter.
local Settings = {}

function Settings:new()
  local o = {}
  setmetatable(o, self)
  self.__index = self

  -- configure your settings here
  o.variables = {
    -- csv file names
    ["SchedulePath"] = "schedule.csv",
    ["RemindersPath"] = "reminders.csv",

    -- csv delimiter based on your locale (most use `,`)
    ["Delimiter"] = ",",

    -- sunday first day of the week
    ["ISOWeek"] = true,

    -- status colors
    -- change the number after the [
    -- for reference: https://en.wikipedia.org/wiki/ANSI_escape_code#3-bit_and_4-bit
    ["Upcoming"] = "\27[0m",
    ["Ongoing"] = "\27[32m",
    ["Completed"] = "\27[31m",
  }

  return o
end

function Settings:GetVariable(var_name, default)
  if self.variables[var_name] ~= nil then
    return self.variables[var_name]
  end

  if default ~= nil then
    return default
  end

  return nil
end

return Settings
