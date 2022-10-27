local SKIN = {}
local variables = {
  ["Delimiter"] = ","
}

function SKIN:GetVariable(var_name, default)
  return variables[var_name] or default or nil
end

return SKIN
