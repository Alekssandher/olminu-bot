local ffi = require("ffi")
ffi.cdef[[
int convert_image(const char *input_path, const char *output_path, const char *format);
]]

local lib = ffi.load("./c_modules/compiled/convert_image.so")


local function download_file(fs, http, url, path)
    local res, body = http.request("GET", url)
    if res.code ~= 200 then
        error("Falha ao baixar arquivo: HTTP " .. res.code)
    end
    fs.writeFileSync(path, body)
end

return {
    name = "convert-image",
    description = "Convert an image file to other image type.",
    options = {
        {
            name = "file",
            description = "The image file to convert",
            type = 11,
            required = true
        },
        {
            name = "format",
            description = "The target format to convert to",
            type = 3,
            required = true,
            choices = {
                { name = "JPG", value = "JPG" },
                { name = "PNG", value = "PNG" },
                { name = "BMP", value = "BMP" },
                { name = "HDR", value = "HDR" },
            }
        }
        -- ,
        -- {
        --     name = "private response",
        --     description = "Only you will be able to see the response.",
        --     type = 5,
        --     required = false,
        --     value = false
        -- }
    },
    execute = function (interaction, args, http, json, fs)
        local file_option = interaction.data.options[1]
        local format_option = interaction.data.options[2].value

        local attachment = interaction.data.resolved.attachments[file_option.value]
        local url = attachment.url
        local input_filename = attachment.filename
        local output_filename = "converted." .. format_option

        local input_path = "/tmp/" .. input_filename
        local output_path = "/tmp/" .. string.lower(output_filename)

        download_file(fs, http, url, input_path)
        local ok = lib.convert_image(input_path, output_path, format_option)
        print("C returned:", ok)

        
        interaction:reply {
            content = "Conversion Completed `" .. format_option .. "`!",
            file = output_path
        }
    end
}