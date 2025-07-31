local loadEnd = require("libs.env")
loadEnd.load_dotenv(".env") 

local token = loadEnd.get("TOKEN")
local client_id = loadEnd.get("CLIENT_ID")
local guild_id = loadEnd.get("GUILD_ID")

local discordia = require("discordia")
local client = discordia.Client()

local http = require("coro-http")
local json = require("json")
local fs = require("fs")

local function loadCommand(scope, cname)

    local url = ""
    if scope == "guild" then
        url = string.format("https://discord.com/api/v10/applications/%s/guilds/%s/commands", client_id, guild_id)
    else
        url = string.format("https://discord.com/api/v10/applications/%s/commands", client_id)
    end

    local res, body = http.request("GET", url, {
        { "Authorization", "Bot " .. token },
        {"Content-Type", "application/json"}
    })

    if res.code ~= 200 then
        print("Error looking for commands:", res.code, body)
        return
    end

    local data = json.decode(body)

    local found = nil
    for _, command in ipairs(data) do
        if command.name == cname then
            found = command
            break
        end
    end

    if found then
        print(string.format("Command '%s' found! ID: %s", cname, found.id))
    else
        print(string.format("Command '%s' not found.", cname))
    end

    return found.id
end

local function deleteCommand(scope, command_id)
    if scope == "guild" then
        url = string.format("https://discord.com/api/v10/applications/%s/guilds/%s/commands/%s", client_id, guild_id, command_id)
    else
        url = string.format("https://discord.com/api/v10/applications/%s/commands/%s", client_id, command_id)
    end

    local res, body = http.request("DELETE", url, {
        { "Authorization", "Bot " .. token }
    })


    if res.code ~= 204 then
        print("Error deleting command:", res.code, body)
        return
    end

    print("Command deleted.")
end

local function main()
    local args = process.argv
    local scope = args[2] 
    local cname = args[3]

     client:on("ready", function()
        print("Bot connected as:", client.user.username)
        local command = loadCommand(scope, cname)
        deleteCommand(scope, command)
        client:stop()
    end)

    client:run("Bot " .. token)
end

main()