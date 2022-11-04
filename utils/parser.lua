local SKIN = require("settings"):new()
local parser = {}

-- Checks if given file path exists.
function parser.file_exists(file_path)
  local f = io.open(file_path, 'r')
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

-- Parses the CSV at the given path into a 2D table.
function parser.parse_csv(file_path)
  if not parser.file_exists(file_path) then
    error("File " .. file_path .. " does not exist.")
  end

  local sep = SKIN:GetVariable("Delimiter", ",")
  local parsed = {}

  for line in io.lines(file_path) do
    local line_buffer = {}
    local word_buffer = ""

    -- for empty last column
    local char

    -- stringing together words and putting them into a table
    for ch in line:gmatch(".") do
      char = ch
      if char == sep then
        table.insert(line_buffer, word_buffer)
        word_buffer = ""
      else
        word_buffer = word_buffer .. char
      end
    end

    -- if empty last column, the loop above won't append a ""
    if char == "," then
      table.insert(line_buffer, "")
    end

    -- insert the row into the 2d table
    table.insert(parsed, line_buffer)
  end

  return parsed
end

return parser
