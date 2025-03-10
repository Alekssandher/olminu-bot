local function urlencode(str)
    if str then
        str = str:gsub("([^%w _%%%-%.~])", function(c)
            return string.format("%%%02X", string.byte(c))
        end)
        str = str:gsub(" ", "%%20") 
    end
    return str
end

local function searchWiki(target, lang, http, json)

    local encodedUrl = urlencode(target)
    local searchUrl = string.format("https://%s.wikipedia.org/w/rest.php/v1/search/title?limit=1&q=%s", lang, encodedUrl)
    local resSearch, bodySearch = http.request("GET", searchUrl)

    if resSearch.code ~= 200 or not bodySearch then
        print("Research error:", resSearch.code)
        return nil
    end

    local searchData = json.decode(bodySearch)
    if not searchData or not searchData.pages or #searchData.pages == 0 then
        print("We could not find:", target)
        return nil
    end

    local pageKey = searchData.pages[1].key
    local encodedPageKey =  urlencode(pageKey)
    print("Page found:", encodedPageKey)

    local summaryUrl = string.format("https://%s.wikipedia.org/api/rest_v1/page/summary/%s", lang, encodedPageKey)
    local resPage, bodyPage = http.request("GET", summaryUrl)

    if resPage.code ~= 200 or not bodyPage then
        print("Error finding page:", resPage.code)
        return nil
    end

    local data = json.decode(bodyPage)
    print(data)
    return {
        title = data.title,
        text = data.extract,
        url = data.content_urls.desktop.page,
        thumbnailUrl = data.thumbnail and data.thumbnail.source or nil
    }
end

return {
    name = "wiki",
    description = "Get information from Wikipedia",
    options = {
        {
            name = "term",
            description = "Your research",
            type = 3,
            required = true
        },
        {
            name = "language",
            description = "Type a language like pt, en, es",
            type = 3,
            required = false,
            choices = {
                { name = '🇧🇷 Português', value = 'pt' },
                { name = '🇺🇸 English', value = 'en' },
                { name = '🇪🇸 Español', value = 'es' },
                { name = '🇫🇷 Français', value = 'fr' },
                { name = '🇮🇹 Italian', value = 'it' },
                { name = '🇩🇪 Deutsch', value = 'de' },
                { name = '🇯🇵 日本語', value = 'ja' },
                { name = '🇨🇳 中文', value = 'zh' }
            }
        }
    },
    execute = function(interaction, args, http, json)
        if not args.term then
            interaction:reply("You need to provide a search term!")
            return
        end

        local term = args.term
        local lang = args.language or "en"

        local page = searchWiki(term, lang, http, json)
        print(page)
        if not page then
            interaction:reply("It looks like your research was not found.")
            return
        end

        interaction:reply({
            embeds = {{
                title = page.title,
                description = page.text,
                url = page.url,
                thumbnail = { url = page.thumbnailUrl }
            }}
        })
    end
}
