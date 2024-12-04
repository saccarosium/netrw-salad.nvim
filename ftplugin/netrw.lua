vim.keymap.set("n", "<Plug>NetrwSaladDelete", function()
    local netrw_salad = require("netrw_salad.private")
    netrw_salad.delete_file_under_cursor()
end, { buffer = true })

vim.keymap.set("n", "<Plug>NetrwSaladRename", function()
    local netrw_salad = require("netrw_salad.private")
    netrw_salad.rename_file_under_cursor()
end, { buffer = true })

local config = require("netrw_salad.config")

if config.map_keys then
    vim.keymap.set("n", "h", "-^", { remap = true, buffer = true })
    vim.keymap.set("n", "l", "<CR>", { remap = true, buffer = true })
    vim.keymap.set("n", "D", "<Plug>NetrwSaladDelete", { buffer = true })
    vim.keymap.set("n", "R", "<Plug>NetrwSaladRename", { buffer = true })
end
