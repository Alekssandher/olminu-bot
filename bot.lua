local discordia = require('discordia')
require("discordia-slash")
require("discordia-components")

local loadEnd = require("libs.env")
loadEnd.load_dotenv(".env")

local token = loadEnd.get("TOKEN")

local client = discordia.Client():useApplicationCommands()



local fs = require("fs")
local commandsDir = "commands"

local files = fs.readdirSync(commandsDir)

-- Function to load a command by name
local function loadCommand(scope)
     -- List all files in the "commands" directory
    
    for _, file in ipairs(files) do
        if file:match("%.lua$") then  -- Check if the file is a Lua script
            local commandName = file:gsub("%.lua$", "") -- Remove the ".lua" extension

            if commandName == scope then -- Compare with the expected name
                local commandPath = commandsDir .. "/" .. file
                local command = dofile(commandPath) -- Load the file as a module
                
                if command and command.name then
                    
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
-- i don't know why but luvit can't load libs in the other files, so i found this "solution"
local http = require("coro-http")
local json = require('json')
local fs = require('fs')


-- local e = discordia.enums.gatewayIntent

-- client:enableIntents(e.guildMembers, e.guildPresences, e.messageContent, e.guilds)

client:setIntents(33281)
client:on("ready", function()
    print("Bot connected as " .. client.user.username)  
    
end)

client:on('slashCommand', function(interaction, command, args)

	local cmd = loadCommand(command.name)

    if(cmd == nil) then
        interaction:reply("Command not found, remember to register the commands", true)
        return
    end
    
    coroutine.wrap(function()
        local success, err = pcall(function()
            cmd.execute(interaction, args, http, json, fs)
        end)

        if not success then
            interaction:reply("An error occurred while executing the command: " .. command.name, true)
            print("Error executing command:", err)
        end
    end)()
end)

client:on("interactionCreate", function(interaction)
    if interaction.type == 3 and interaction.data.custom_id == "captcha_modal" then
        interaction:Modal({
            title = "Digite o captcha",
            custom_id = "captcha_submit",
            components = {
                {
                    type = 1,
                    components = {
                        {
                            type = 4,
                            custom_id = "captcha_input",
                            label = "Captcha",
                            style = 1,
                            required = true,
                            placeholder = "Digite os caracteres da imagem"
                        }
                    }
                }
            }
        })
    elseif interaction.type == 5 and interaction.data.custom_id == "captcha_submit" then
        local captcha_value = interaction.data.components[1].components[1].value
        interaction:reply({
            content = "Você digitou: `" .. captcha_value .. "`",
            ephemeral = true
        })

    
    end
end)

client:run('Bot ' .. token)

