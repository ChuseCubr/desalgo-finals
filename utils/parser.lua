local SKIN = require("dummy")
local parser = {}

function parser.file_exists(file_path)
  local f = io.open(file_path, 'r')
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

function parser.parse(file_path)
  if not parser.file_exists(file_path) then
    return nil
  end

  local sep = SKIN:GetVariable("Delimiter", "")
  local parsed = {}

  for line in io.lines(file_path) do
    local line_buffer = {}
    local word_buffer = ""

    for char in line:gmatch(".") do
      if char == sep then
        table.insert(line_buffer, word_buffer)
        word_buffer = ""
      else
        word_buffer = word_buffer .. char
      end
    end

    table.insert(parsed, line_buffer)
  end

  return parsed
end

return parser
