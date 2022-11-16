-- Authors: Algoholics (Chase Villarroel,
--                      Sayaka Aliyah Hernandez,
--                      Shane Crisvy Ricafort)
-- Date: November 16, 2022
--
-- Description:
--     Contains parser class definition.
--     Static class with methods for parsing files.
--
-- References:
--   * Lua Documentation (https://www.lua.org/manual/5.4/)

local parser = {}

-- Checks if given file path exists.
-- Args:
--     file_path (str): File name/path.
function parser.file_exists(file_path)
  local f = io.open(file_path, 'r')
  if f ~= nil then
    -- file was successfully opened, close and return true
    io.close(f)
    return true
  else
    -- if failed to open, return false
    return false
  end
end

-- Parses the CSV at the given path into a 2D table.
-- Args:
--     file_path (str): CSV file name/path.
--     sep (str): CSV separator based on locale (Default is ",").
-- Returns:
--     2D array (table) of file contents
function parser.parse_csv(file_path, sep)
  if not parser.file_exists(file_path) then
    error("File " .. file_path .. " does not exist.")
  end

  -- final table
  local parsed = {}
  -- CSV separator
  sep = sep or ","

  for line in io.lines(file_path) do
    -- for building up each line
    local line_buffer = {}
    -- for building each cell
    local word_buffer = ""

    -- stringing together words and putting them into a table
    -- for each character...
    for ch in line:gmatch(".") do
      local char = ch
      if char == sep then
        -- if current character is the separator, add word built so far to
        -- line buffer and reset word buffer
        table.insert(line_buffer, word_buffer)
        word_buffer = ""
      else
        -- if not, just keep building the word
        word_buffer = word_buffer .. char
      end
    end

    -- last column won't have separator after, so manually add the word
    table.insert(line_buffer, word_buffer)

    -- insert the row into the 2d table
    table.insert(parsed, line_buffer)
  end

  -- return final table
  return parsed
end

return parser
