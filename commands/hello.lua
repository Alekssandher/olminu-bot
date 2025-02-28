return {
    name = "hello",
    description = "Diz Olá!",
    options = {
        {
            name = "nome",
            type = 3, 
            description = "Seu nome",
            required = false
        }
    },
    execute = function(interaction, args)
        local nome = interaction.data.options and interaction.data.options[1] and interaction.data.options[1].value or "mundo"
        interaction:reply("👋 Olá, " .. nome .. "!", true)
    end
}
