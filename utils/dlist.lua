-- Authors: Algoholics (Chase Villarroel,
--                      Sayaka Aliyah Hernandez,
--                      Shane Crisvy Ricafort)
-- Date: November 16, 2022
--
-- Description:
--     Contains the linked list class definition.
--     Implemented as a doubly linked list with methods for iterating,
--     appending, removing, and printing.
--
-- References:
--   * Lua Documentation (https://www.lua.org/manual/5.4/)
--   * DESALGO Lecture

-- Initialize base classes
local LinkedList = {}
local Node = {}

-- Node class constructor.
-- Building block for linked lists.
-- Args:
--     value (any): Data for the node.
--     prev (Node): Pointer to previous node.
--     next (Node): Pointer to next node.
function Node:new(value, prev, next)
  -- create empty object
  local o = {}
  -- give it the methods defined here
  setmetatable(o, self)
  -- define object's self
  self.__index = self
  -- object attributes
  o.value = value
  o.prev = prev or nil
  o.next = next or nil
  return o
end

-- Doubly linked list class constructor.
function LinkedList:new()
  -- create empty object
  local o = {}
  -- give it the methods defined here
  setmetatable(o, self)
  -- define object's self
  self.__index = self
  -- object attributes
  o.head = nil
  o.ptr = o.head
  o.tail = nil
  o.len = 0
  return o
end

-- Checks whether the list is empty.
function LinkedList:is_empty()
  return self.len == 0
end

-- Metamethod for getting the length using # (Lua's collection size syntax).
function LinkedList:__len()
  return self.len
end

-- Gets the value at the current pointer.
function LinkedList:peek()
  if self.ptr == nil then
    return nil
  end
  return self.ptr.value
end

-- Gets the value at the current pointer and increments the pointer.
function LinkedList:iterate()
  if self.ptr == nil then
    return nil
  end
  local value = self.ptr.value
  self.ptr = self.ptr.next
  return value
end

-- Resets the pointer to the head of the list.
function LinkedList:reset()
  self.ptr = self.head
end

-- Inserts a value into the end of the list.
function LinkedList:append(value)
  if self.len == 0 then
    -- if empty, initialize list
    self.head = Node:new(value)
    self.ptr = self.head
    self.tail = self.head
  else
    -- else, append to tail
    self.tail.next = Node:new(value, self.tail, self.head)
    self.tail = self.tail.next
  end
  -- update length
  self.len = self.len + 1
end

-- Removes and returns the value at the pointer
function LinkedList:remove()
  if self.ptr == nil then
    -- error handling
    error("Attempted to remove at empty pointer.")
  end

  if self.ptr.prev == nil then
    -- if head, make the next node the head
    self.head = self.head.next
    self.head.prev = nil
  else
    -- if not, make the prev node point to the next
    self.ptr.prev.next = self.ptr.next
  end

  if self.ptr.next == nil then
    -- if tail, make the prev node the tail
    self.tail = self.tail.prev
    self.tail.next = nil
  else
    -- if not, make the next node point to the prev
    self.ptr.next.prev = self.ptr.prev
  end

  -- update pointer and length
  local value = self.ptr.value
  self.ptr = self.ptr.next
  self.len = self.len - 1
  return value
end

-- Override metamethod for easier printing.
-- Converts the collection into a string for debugging purposes.
function LinkedList:__tostring()
  if self.len == 0 then
    -- if empty, return empty string
    return ""
  end

  -- convert first node
  local stringed = tostring(self:peek())

  -- convert the rest of the nodes with commas
  for _ = 2, self.len, 1 do
    stringed = stringed .. ", "
    stringed = stringed .. tostring(self:iterate())
  end

  return stringed
end

return LinkedList
