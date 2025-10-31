
local ffi = require("ffi")
ffi.cdef[[
int convert_image(const char *input_path, const char *output_path);
]]

local lib = ffi.load("./c_modules/compiled/convert_image.so")
return {
    name = "convert-image",
    description = "Convert an image file to other image type.",
    execute = function (interaction)
        interaction:reply("result: "..lib.convert_image("", ""))
    end
}