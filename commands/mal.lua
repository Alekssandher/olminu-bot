
local function search(kind, term, http, json)
    local encoded_term = term:gsub(" ", "%%20")
    local url
    if kind == "anime" then
        url = string.format("https://api.jikan.moe/v4/anime?q=%s&limit=1", encoded_term)
    elseif kind == "character" then
        url = string.format("https://api.jikan.moe/v4/characters?q=%s&limit=1", encoded_term)
    end
    

    local res, body = http.request("GET", url)

    if res.code ~= 200 then
        print("Erro na requisição:", res.reason)
        return
    end
    
    local data = json.decode(body)

    if data and data.data and #data.data > 0 then
        return data.data[1]
    else
        return nil;
    end

end
local function animeResponse(interaction, result)

    local genreNames = {}
    if result.genres then
        for _, genre in ipairs(result.genres) do
            table.insert(genreNames, genre.name)
        end
    end
    local genresString = table.concat(genreNames, ", ") or "Unknown"

    local embed = {
        title = result.title,
        url = result.url,
        thumbnail = { url = result.images.jpg.image_url },
        color = 15395529, 
        fields = {
            {
                name = "Score & Ranking",
                value = string.format("**Score:** %s \n**Ranking:** #%s", result.score or "N/A", result.rank or "N/A"),
                inline = true
            },
            {
                name = "Genres",
                value = genresString,
                inline = true
            },
            {
                name = "Release date",
                value = result.aired and result.aired.string or "Unknown",
                inline = true
            },
            {
                name = "Status",
                value = result.status or "Unknown",
                inline = true
            },
            {
                name = "Episodes quantity",
                value = tostring(result.episodes or "Unknown"),
                inline = true
            },
            {
                name = "Duration per ep",
                value = result.duration or "Unknown",
                inline = true
            },
            {
                name = "Studio",
                value = result.studios and result.studios[1] and result.studios[1].name or "Unknown",
                inline = true
            },
            {
                name = "Synopsis",
                value = result.synopsis and result.synopsis:sub(1, 1020) .. "..." or "No synopsis available.",
            },
            {
                name = "Background",
                value = result.background and result.background:sub(1, 1020) .. "..." or "No background available.",
            }
        },
        footer = {
            text = string.format("%s - Information from MyAnimeList", interaction.user.username)
        },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ") 
    }
    interaction:reply({ embed = embed })
end
local function characterResponse(interaction, char)

    local embed = {
        title = char.name,
        url = char.url,
        thumbnail = {
            url = char.images.jpg.image_url
        },
        fields = {
            {
                name = "Name",
                value = char.name,
                inline = true
            },
            {
                name = "Kanji Name",
                value = char.name_kanji or 'This char has no kanji name',
                inline = true
            },
            {
                name = "Nickname",
                value = char.nicknames and #char.nicknames > 0 and char.nicknames[1] or char.name .. " has no nickname.",
                inline = true
            },
            {
                name = "About",
                value =  char.about and char.about:sub(1, 1020) .. "..." or "This character has no about"
            }
        },
        footer = {
            text = string.format("%s - Information from MyAnimeList", interaction.user.username)
        },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }
    
    interaction:reply({ embed = embed })
    if char.name == 'Olminu' and math.random(1,50) == 1 then 
        interaction:reply("she looks like me, what a beautiful lady")
    end
end
do return {
    name = "mal",
    description = "Make a research on My Anime List",
    options = {
        {
            name = "kind",
            type = 3, 
            description = "Are you looking for an anime or a character?",
            required = true,
            choices = {
                {name = "Anime", value = "anime"},
                {name = "Character", value = "character"}
            }
        },
        {
            name = "terms",
            description = "Type your anime/char name",
            type = 3,
            required = true
        }
    },
    execute = function(interaction, args, http, json)
        
        local result = search(args.kind, args.terms, http, json)
        
        
        if result == nil then
            interaction:reply("Not found, did you type it right? ", false)
            return
        end

        if args.kind == "anime" then
            animeResponse(interaction, result)
            return;
        elseif args.kind == "character" then
            characterResponse(interaction, result)
            return;
        
        end
        
        
    end
} end

