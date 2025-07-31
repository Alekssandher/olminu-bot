<div align="center">
    
# Olminu Bot  
![olminu](https://github.com/user-attachments/assets/4c40c886-4127-4498-981a-d6a9e5ed932a)



**Olminu Bot** is a Discord bot developed using Lua and Discordia.

![GitHub License](https://img.shields.io/github/license/Alekssandher/olminu-bot?style=flat-square)
![Contributors](https://img.shields.io/github/contributors/Alekssandher/olminu-bot?style=flat-square)
![Last Commit](https://img.shields.io/github/last-commit/Alekssandher/olminu-bot?style=flat-square)
</div>

---

### Why Olminu?
The bot is named after Olminu, a character from the manga *Drifters*. As a fan of the character, I chose to name the bot in her honor.

## Table of Contents
- [Inviting Bot](#inviting-bot)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Setting Up](#setting-up)
- [Running the Project](#running-the-project)
- [Registering Slash Commands](#registering-slash-commands)
- [Deleting Slash Commands](#deleting-slash-commands)
- [Seeing local/registred commands](#seeing-local/registred-commands)
- [Contribution](#contribution)
- [License](#license)

## Inviting Bot
You can add Olminu to your Discord server by following this [link](https://discord.com/oauth2/authorize?client_id=1303531869878358036) and inviting her.

## Prerequisites
- [Lua](https://www.lua.org/) (version 5.4 or higher)
- [Luvit](https://luvit.io/)
- [Discordia](https://github.com/SinisterRectus/Discordia)

## Installation

1. Clone this repository with the submodules:
    ```bash
    git clone --recurse-submodules https://github.com/Alekssandher/Olminu-Bot-Lua.git
    ```
2. Navigate to the project directory:
    ```bash
    cd olminu-bot
    ```
3. Install dependencies:
    ```bash
    lit install SinisterRectus/discordia
    ```

## Setting Up

1. Log in to the [Discord Developer Portal](https://discord.com/developers) and create a new application.
> **Note**: Make sure to configure it properly.
2. Create a `.env` file in the root folder.
    - Check the `.env.example` file for the required variables.
3. Replace the placeholder values with your bot's credentials.

> **Note**: For testing, create a dedicated Discord server. Use the `GUILD_ID` environment variable to restrict commands to that server.

## Running the Project

Run the main file using the following command:

```bash
luvit bot.lua
```

## Registering Slash Commands
Before registering a command you will need to have at least a command in the ./command/ folder, take a look how one of your commands file should be like:
```lua
  return {
    name = "ping",
    description = "Replies with Pong!",
    execute = function(interaction, args, http, json) 
        
        interaction:reply("🏓 Pong!", true)
    end
}
```
Registering commands is simple. Use the scripts provided in the repository.
Commands can be registered globally or restricted to a specific guild.

```bash
# To register guild command
luvit scripts/registerGuildCommand.lua <command name in accord to file names in ./commands/>
```
```bash
# To register global command
luvit scripts/registerGlobalCommands.lua <command name in accord to file names in ./commands/>
```
> Note: Global command registration might take up to an hour to propagate across all servers. Guild commands are updated instantly.
## Deleting Slash Commands
If you need to remove registered commands, you can use the delete command script. This is useful when cleaning up old commands or removing test commands.

```bash
# To delete a guild command
luvit scripts/deleteCommand.lua guild <command name>
```
```bash
# To delete a global command
luvit scripts/deleteCommand.lua global <command name>
```

The delete script will:
1. Search for the command by name in the specified scope (guild or global)
2. Display the command ID if found
3. Delete the command from Discord's servers
4. Confirm successful deletion

> **Note**: Like registration, global command deletion might take some time to propagate across all servers, while guild command deletion is instant.

## Seeing local/registred commands
To see the commands already registred and the local commands use this script:
```bash
luvit scripts/getApplicationCommands.lua
```
## Contribution
If you want to contribute to the project, feel free to open an issue or submit a pull request. All contributions are welcome!

## License
This project is licensed under the GNU General Public License (GPL) version 3. You are free to use, modify, and distribute this software, provided that all copies and derivatives are also licensed under GPL v3.

For more details, see the [LICENSE](https://github.com/Alekssandher/olminu-bot/blob/main/LICENSE) file included in this repository.

