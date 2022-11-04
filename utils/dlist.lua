local LinkedList = {}
local Node = {}

-- Node class constructor.
-- Building block for queues.
function Node:new(value, prev, next)
  local o = {}
  setmetatable(o, self)
  self.__index = self
  o.value = value
  o.prev = prev or nil
  o.next = next or nil
  return o
end

-- Doubly linked list class constructor.
-- Implemented as a singly linked list.
function LinkedList:new()
  local o = {}
  setmetatable(o, self)
  self.__index = self
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

-- Metamethod for getting the length using #.
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

-- Increments the pointer and gets the new value.
function LinkedList:increment()
  if self.ptr == nil then
    return nil
  end
  self.ptr = self.ptr.next
  return self:peek()
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
    return
  end

  local value = self.ptr.value

  if self.len == 1 then
    self.head = nil
    self.tail = nil
    self.ptr = self.head
    self.len = 0
    return value
  end

  -- if the pointer is at the head/tail, change it as well
  if self.ptr == self.head then
    self.head = self.head.next
  end
  if self.ptr == self.tail then
    self.tail = self.tail.prev
    self.tail.next = nil
  end

  -- if the prev/next exists, change the link to it as well
  if self.ptr.prev ~= nil then
    self.ptr.prev.next = self.ptr.next
  end
  if self.ptr.next ~= nil then
    self.ptr.next.prev = self.ptr.prev
  end

  -- update pointer and length
  self.ptr = self.ptr.next
  self.len = self.len - 1
  return value
end

-- Override metamethod for easier printing.
-- For debugging purposes.
function LinkedList:__tostring()
  if self.len == 0 then
    return ""
  end

  local stringed = tostring(self:peek())

  for _ = 2, self.len, 1 do
    stringed = stringed .. ", "
    stringed = stringed .. tostring(self:increment())
  end

  return stringed
end

return LinkedList
