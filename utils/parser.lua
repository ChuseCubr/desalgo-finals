local SKIN = require("dummy")
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

-- Parses the CSV files at each file path in the given table.
-- Parsed data is in the form of a 3D table: a 2D table with each cell
-- containing a table of the parsed values from that corresponding cell
-- in each file.
-- For mouse actions.
function parser.bulk_parse(file_paths)
  for path in file_paths do
    local parsed = parser.parse_csv(path)
    for row in parsed do
      for col in parsed do
      end
    end
  end
end

return parser
