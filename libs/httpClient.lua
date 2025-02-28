-- libs/httpClient.lua
local http = require("coro-http")

local httpClient = {}

function httpClient.get(url)
    local res, body = http.request("GET", url)
    return res, body
end

return httpClient