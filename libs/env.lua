local DotEnv = {}
local env_vars = {}

function DotEnv.get(key, default)
  local value = env_vars[key] or os.getenv(key)
  return value or default
end

function DotEnv.load_dotenv(file_path)
  file_path = file_path or "./.env"
  local file = io.open(file_path, "r")
  if not file then
    print(".env file not found in:", file_path)
    return
  end

  for line in file:lines() do
    local key, value = line:match("^([%w_]+)%s*=%s*(.+)$")
    if key and value then
      value = value:gsub("^[\"'](.-)[\"\']$", "%1")
      env_vars[key] = value
    end
  end


  file:close()
end

return DotEnv