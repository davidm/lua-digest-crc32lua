--[[
 digest.crc32
 CRC-32 checksum implemented entirely in Lua.  This is similar to [1-2].

 Dependencies:
   BitOp "bit", Lua 5.2 "bit32", or "bit.numberlua" (>=000.003).

 References
   [1] http://www.axlradius.com/freestuff/CRC32.java
   [2] http://www.gamedev.net/reference/articles/article1941.asp
   [3] http://java.sun.com/j2se/1.5.0/docs/api/java/util/zip/CRC32.html
   [4] http://www.dsource.org/projects/tango/docs/current/tango.io.digest.Crc32.html
   [5] http://pydoc.org/1.5.2/zlib.html#-crc32
   [6] http://www.python.org/doc/2.5.2/lib/module-binascii.html
 
 (c) 2008-2011 David Manura.  Licensed under the same terms as Lua (MIT).
--]]


local M = {_TYPE='module', _NAME='digest.crc32', _VERSION='000.003.2011-11-28'}

local type = type
local require = require
local setmetatable = setmetatable

--[[
 Requires the first module listed that exists, else raises like `require`.
 If a non-string is encountered, it is returned.
 Second return value is module name loaded (or '').
 --]]
local function requireany(...)
  local errs = {}
  for _,name in ipairs{...} do
    if type(name) ~= 'string' then return name, '' end
    local ok, mod = pcall(require, name)
    if ok then return mod, name end
    errs[#errs+1] = mod
  end
  error(table.concat(errs, '\n'), 2)
end

local bit, name_ = requireany('bit', 'bit32', 'bit.numberlua')
local bxor = bit.bxor
local bnot = bit.bnot
local band = bit.band
local rshift = bit.rshift

-- CRC-32-IEEE 802.3 (V.42)
local POLY = 0xEDB88320

local function memoize(f)
  local mt = {}
  local t = setmetatable({}, mt)
  function mt:__index(k)
    local v = f(k); t[k] = v
    return v
  end
  return t
end

local crc_table = memoize(function(i)
  local crc = i
  for _=1,8 do
    local b = band(crc, 1)
    crc = rshift(crc, 1)
    if b == 1 then crc = bxor(crc, POLY) end
  end
  return crc
end)


function M.crc32_byte(byte, crc)
  crc = bnot(crc or 0)
  local v1 = rshift(crc, 8)
  local v2 = crc_table[bxor(crc % 256, byte)]
  return bnot(bxor(v1, v2))
end
local M_crc32_byte = M.crc32_byte


function M.crc32_string(s, crc)
  crc = crc or 0
  for i=1,#s do
    crc = M_crc32_byte(s:byte(i), crc)
  end
  return crc
end
local M_crc32_string = M.crc32_string


function M.crc32(s, crc)
  if type(s) == 'string' then
    return M_crc32_string(s, crc)
  else
    return M_crc32_byte(s, crc)
  end
end


M.bit = bit  -- bit library used


return M


--[[
LICENSE

Copyright (C) 2008-2011, David Manura.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

(end license)
--]]
