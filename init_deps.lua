local root = debug.getinfo(1, "S").source:sub(2):match("(.*/)")
package.path = root .. "deps/?.lua;" .. root .. "deps/?/init.lua;" .. package.path