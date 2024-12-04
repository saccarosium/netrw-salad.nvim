local config = require("netrw_salad.config")

if config.configure_netrw then
    vim.g.netrw_hide = 0
    vim.g.netrw_preview = 1
    vim.g.netrw_altfile = 1
end

if config.map_keys then
    vim.keymap.set("n", "-", function()
        vim.cmd.Explore()
        vim.fn.search(vim.fs.normalize(vim.fn.expand("#:t")), "zW")
    end)
end
