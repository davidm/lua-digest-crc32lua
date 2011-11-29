-- tests of digest.crc32lua

package.path = '../lua-bit-numberlua/lmod/?.lua;' .. package.path
package.path = 'lmod/?.lua;' .. package.path
local CRC = require 'digest.crc32lua'

local function checkeq(a, b)
  if a ~= b then error('not equal\n'..tostring(a)..'\n'..tostring(b)) end
end

-- normalization (BitOp)
local tobit = CRC.bit.tobit or function(x) return x end

checkeq(CRC.crc32_string'', tobit(0))
checkeq(CRC.crc32_string'test', tobit(0xD87F7E0C))

checkeq(CRC.crc32('st', CRC.crc32('te')), tobit(0xD87F7E0C))

print 'DONE'
