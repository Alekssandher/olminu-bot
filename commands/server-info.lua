local loadEnd = require("libs.env")
loadEnd.load_dotenv(".env")

local client_id = loadEnd.get("CLIENT_ID")
local token = loadEnd.get("TOKEN")

local function iso8601ToTimestamp(isoString)
    local year, month, day, hour, min, sec = isoString:match("(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)")

    return os.time({
        year = tonumber(year),
        month = tonumber(month),
        day = tonumber(day),
        hour = tonumber(hour),
        min = tonumber(min),
        sec = tonumber(sec),
        isdst = false  
    })
end

local function fetchUser(userId, http, json)
    local url = string.format("https://discord.com/api/v10/users/%s", userId)

    local headers = {
        {"Authorization", "Bot " .. token},
        {"Content-Type", "application/json"}
    }

    local res, body = http.request("GET", url, headers)

    if res.code == 200 then
        return json.decode(body)
    else
        return nil 
    end
end
return {
    name = "server-info",
    description = "Show server information.",
    execute = function(interaction, args, http, json)
        coroutine.wrap(function()
            local guild = interaction.channel.guild
            local ownerId = guild.ownerId or "Unknown"

            local owner = fetchUser(ownerId, http, json)
            local ownerName = owner and owner.username or "Unknown"

            local textChannels = guild.textChannels:count()
            local voiceChannels = guild.voiceChannels:count()
            local memberCount = guild.totalMemberCount
            local totalChannels = textChannels + voiceChannels

            local createdAt = math.floor(guild.createdAt)
            local joinedAt = iso8601ToTimestamp(guild.joinedAt)

            local embed = {
                title = guild.name,
                thumbnail = {
                    url = string.format("https://cdn.discordapp.com/icons/%s/%s.jpg", guild.id, guild.icon)
                },
                color = 15395529,
                fields = {
                    { 
                        name = "ID",
                        value = guild.id,
                        inline = true
                    },
                    { 
                        name = "Owner",
                        value = string.format("`%s` (`%s`)",
                        ownerName, ownerId),
                        inline = true
                    },
                    {
                        name = "Created At",
                        value = string.format("<t:%s:f> (<t:%s:R>)",
                        createdAt, createdAt),
                        inline = true
                    },
                    {
                        name = string.format("Channels (%s)",
                        totalChannels),
                        value = string.format("Text channels: %s\nVoice channels: %s",
                        textChannels or 0, voiceChannels or 0),
                        inline = true
                    },
                    {
                        name = "Members",
                        value = memberCount,
                        inline = true
                    },
                    {
                        name = "I joined at",
                        value = string.format("<t:%s:f> (<t:%s:T>)",
                        joinedAt, joinedAt),
                        inline = true
                    }
                },
                footer = { text = string.format("%s", interaction.user.username) },
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }

            interaction:reply({ embed = embed })
        end)()
    end
}