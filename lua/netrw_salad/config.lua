local ERROR_MSG = "Config is malformed. It can be either a table or a function that returns a table"

local defaults = {
    configure_netrw = true,
    map_keys = true,
}

if vim.g.no_plugin_maps then
    defaults.map_keys = false
end

local user_config = vim.g.netrw_salad or {}
if type(user_config) == "table" then
    user_config = user_config
elseif type(user_config) == "function" then
    local res = user_config(defaults)
    assert(type(res) == "table" and not vim.islist(res), ERROR_MSG)
    user_config = res
else
    error(ERROR_MSG, 0)
end

local config = vim.tbl_extend("force", defaults, user_config)
return setmetatable(config, {
    __newindex = function()
        error("Config is read-only", 0)
    end,
})
