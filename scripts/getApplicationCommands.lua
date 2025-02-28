local http = require("coro-http")
local json = require("json")

local loadEnd = require("libs.env")
loadEnd.load_dotenv(".env")

local token = loadEnd.get("TOKEN")
local client_id = loadEnd.get("CLIENT_ID")
local guild_id = loadEnd.get("GUILD_ID")

-- URL to get command from guild
local url = "https://discord.com/api/v10/applications/" .. client_id .. "/guilds/" .. guild_id .. "/commands"

local headers = {
    {"Authorization", "Bot " .. token},
    {"Content-Type", "application/json"}
}

-- GET request
local res, body = http.request("GET", url, headers)

-- Show discord API status response
print("DISCORD API RESPONSE STATUS:", res.code)

-- Decode JSON API response
local commands = json.decode(body)
print("---------GUILD COMMANDS---------\n")
if commands then
    for _, command in ipairs(commands) do
        print(command.name, "-",command.description)
    end
else
    print("Erro ao decodificar JSON")
end

-- Load local commands
local fs = require("fs")

local commands = {} -- Table to save commands

local commandsDir = "commands"
local files = fs.readdirSync(commandsDir)

print("\n---------LOCAL COMMANDS---------")
for _, file in ipairs(files) do
    if file:match("%.lua$") then  -- Check if the file is a lua file
        local commandName = file:gsub("%.lua$", "") -- Removes ".lua" extension
        local commandPath = commandsDir .. "/" .. file
        local command = dofile(commandPath) -- Loads files from a module
        
        if command and command then
            commands[command.name] = command -- Stores the commands in a table
        else
            print("Erro ao carregar comando:", file)
        end
    end
end

-- Show the commands and description
for name, cmd in pairs(commands) do
    print(name, "-", cmd.description)
end

