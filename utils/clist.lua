local Queue = {}
local Node = {}

-- Node class constructor.
-- Building block for queues.
function Node:new(value, prev)
  local o = {}
  setmetatable(o, self)
  self.__index = self
  o.value = value
  o.prev = prev or nil
  o.next = nil
  return o
end

-- Queue class constructor.
-- Implemented as a singly linked list.
function Queue:new()
  local o = {}
  setmetatable(o, self)
  self.__index = self
  o.head = nil
  o.tail = nil
  o.len = 0
  return o
end

-- Checks whether the queue is empty.
function Queue:is_empty()
  return self.len == 0
end

-- Metamethod for getting the length using #.
function Queue:__len()
  return self.len
end

-- Gets the next value in the queue without removing it.
function Queue:peek()
  return self.head.value
end

-- Inserts a value into the start of the queue.
-- (More of a stack/deque thing than a queue thing,
--  but useful for decluttering.)
function Queue:push(value)
  local new = Node:new(value)
  new.next = self.head
  self.head = new
  self.len = self.len + 1
end

-- Inserts a value into the end of the queue.
function Queue:enqueue(value)
  if self.len == 0 then
    self.head = Node:new(value)
    self.tail = self.head
  else
    self.tail.next = Node:new(value, self.tail)
    self.tail = self.tail.next
  end
  self.len = self.len + 1
end

-- Removes and returns the value from the start of the queue.
function Queue:dequeue()
  if self.head == nil then
    error("Attempted to dequeue from an empty queue.")
  end
  local value = self.head.value
  self.head = self.head.next
  self.len = self.len - 1
  return value
end

-- Override metamethod for easier printing.
-- For debugging purposes.
function Queue:__tostring()
  if self.head == nil then
    return nil
  end

  local stringed = ""
  local here = self.head

  while here ~= nil do
    stringed = stringed .. tostring(here.value)
    here = here.next
    if here ~= nil then
      stringed = stringed .. ", "
    end
  end

  return stringed
end

return Queue
