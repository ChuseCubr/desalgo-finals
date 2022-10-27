local SKIN = {}
local variables = {
  ["Delimiter"] = ","
}

function SKIN:GetVariable(var_name, default)
  if variables[var_name] ~= nil then
    return variables[var_name]
  end
  if default ~= nil then
    return default
  end
  return nil
end

return SKIN
