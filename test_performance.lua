-- Performance test of digest.crc32lua.

package.path = '../lua-bit-numberlua/lmod/?.lua;' .. package.path
package.path = '../lua-digest-crc32lua/lmod/?.lua;' .. package.path
local CRC = require 'digest.crc32lua'

local s = ('ymn32h8hm8emdh8mdhasdmfa32mkrwjkrn9fgtu44rr'):rep(10000)

CRC.crc32(s)
