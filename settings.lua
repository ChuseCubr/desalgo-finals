-- Authors: Algoholics (Chase Villarroel,
--                      Sayaka Aliyah Hernandez,
--                      Shane Crisvy Ricafort)
-- Date: November 16, 2022
--
-- Description:
--     Contains the settings class definition.
--     Meant to emulate some Rainmeter object functions.
--     Allows user to change program behavior.
--
-- References:
--   * Lua Documentation (https://www.lua.org/manual/5.4/)

-- Initialize base class
local Settings = {}

-- Settings class constructor
function Settings:new()
  -- create empty object
  local o = {}
  -- give it the methods defined here
  setmetatable(o, self)
  -- define object's self
  self.__index = self

  -- object attributes
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

-- Returns the value of the given setting name.
-- If setting is not found, returns nil or given default.
-- Args:
--     var_name (str): Name of the setting.
--     default (any): The value if the setting is not found.
function Settings:GetVariable(var_name, default)
  if self.variables[var_name] ~= nil then
    -- if setting is found.
    return self.variables[var_name]
  end

  if default ~= nil then
    -- if setting is not found and default is specified.
    return default
  end

  -- if setting is not found and default is not specified.
  return nil
end

return Settings
