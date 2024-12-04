local defaults = {
    configure_netrw = true,
    map_keys = true,
}

local config = vim.tbl_extend("force", defaults, vim.g.netrw_salad or {})
if vim.g.no_plugin_maps then
    config.map_keys = false
end

return setmetatable(config, {
    __newindex = function()
        error("Config is read-only", 0)
    end,
})
