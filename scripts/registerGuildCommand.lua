local loadEnd = require("libs.env")
loadEnd.load_dotenv(".env") 

local token = loadEnd.get("TOKEN")
local client_id = loadEnd.get("CLIENT_ID")
local guild_id = loadEnd.get("GUILD_ID")

local discordia = require("discordia")
local client = discordia.Client()

local commandsDir = "commands"
local http = require("coro-http")
local json = require("json")
local fs = require("fs")

-- Function to load a command by name
local function loadCommand(scope)
    local files = fs.readdirSync(commandsDir) -- List all files in the "commands" directory
    
    for _, file in ipairs(files) do
        if file:match("%.lua$") then  -- Check if the file is a Lua script
            local commandName = file:gsub("%.lua$", "") -- Remove the ".lua" extension

            if commandName == scope then -- Compare with the expected name
                local commandPath = commandsDir .. "/" .. file
                local command = dofile(commandPath) -- Load the file as a module
                
                if command and command.name then
                    print("Command loaded:", command.name)
                    return command -- Returns the specific command loaded
                else
                    print("Error loading command:", file)
                    return nil
                end
            end
        end
    end
    
    print("Command not found:", scope)
    return nil
end

-- Function to register the command in a specific guild on the Discord API
local function registerCommand(command)
    if not command then
        print("No command to register.")
        return
    end

    local url = "https://discord.com/api/v10/applications/" .. client_id .. "/guilds/" .. guild_id .. "/commands"

    local headers = {
        {"Authorization", "Bot " .. token},
        {"Content-Type", "application/json"}
    }

    local body = {
        name = command.name,
        description = command.description,
        options = command.options or {},
        type = 1
    }

    local res, responseBody = http.request("POST", url, headers, json.encode(body))

    print("Discord API response:", res.code, responseBody)
end

-- Main function
local function main()
    local args = process.argv
    local scope = args[2] -- Get the argument - Must be a valid command name

    client:on("ready", function()
        print("Bot connected as:", client.user.username)
        local command = loadCommand(scope)
        registerCommand(command)
        client:stop()
    end)

    client:run("Bot " .. token)
end

main()
