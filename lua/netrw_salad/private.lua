-- Netrw Helpers: {{{

local function netrw_refresh()
    local key = vim.api.nvim_replace_termcodes("<Plug>NetrwRefresh", true, false, true)
    vim.api.nvim_feedkeys(key, "n", false)
end

local function netrw_get_current_file()
    local line = vim.api.nvim_get_current_line()
    line = vim.fn.substitute(line, "\\*$", "", "")
    local dir = vim.b.netrw_curdir

    local file = vim.fs.joinpath(dir, line)
    if line == "./" or line == "../" then
        file = line
    end

    return file
end

-- }}}
-- Buffer Cleaners: {{{

local function get_buf_handle_from(path)
    local buffers = vim.iter(vim.api.nvim_list_bufs())

    local handle = buffers
        :filter(vim.api.nvim_buf_is_loaded)
        :map(function(x)
            return { x, vim.api.nvim_buf_get_name(x) }
        end)
        :find(function(x)
            return path == x[2]
        end)

    if handle then
        return handle[1]
    end
end

local function buf_delete_open(path)
    local buf_handle = get_buf_handle_from(path)
    if not buf_handle then
        return
    end

    vim.api.nvim_buf_delete(buf_handle, { force = true })
end

local function buf_rename_open(src, dst)
    local buf_handle = get_buf_handle_from(src)
    if not buf_handle then
        return
    end

    vim.api.nvim_buf_set_name(buf_handle, dst)
end

-- }}}
-- Action Functions: {{{

local function delete(path, opts)
    local isdir = vim.fn.isdirectory(path) == 1
    local return_code = 0

    if isdir and opts.recursive then
        return_code = vim.fn.delete(path, "rf")
    elseif isdir then
        return_code = vim.fn.delete(path, "d")
    else
        return_code = vim.fn.delete(path)
    end

    if return_code == -1 then
        vim.notify("Failed to delete the file", vim.log.Error)
        return
    end

    buf_delete_open(path)
    netrw_refresh()
end

local function rename(src, dst)
    local return_code = vim.fn.rename(src, dst)
    if return_code ~= 0 then
        vim.notify("Failed to rename the file", vim.log.Error)
        return
    end

    buf_rename_open(src, dst)
    netrw_refresh()
end

-- }}}
-- Exports: {{{

local M = {}

function M.delete_file_under_cursor()
    local path = netrw_get_current_file()
    local isdir = vim.fn.isdirectory(path) == 1
    local choices = isdir and "[y(es),n(o),a(ll)]" or "[y(es),n(o)]"
    local msg = ("Confirm deletion of <%s> %s "):format(path, choices)

    vim.ui.input({ prompt = msg }, function(ans)
        if vim.fn.empty(ans) == 1 then
            return
        end

        if isdir and ans:match("a[l|ll]?") then
            delete(path, { recursive = true })
        elseif ans:match("y[e|es]?") then
            delete(path)
        elseif ans:match("no?") then
            return
        else
            vim.notify(("%q is not a valid answer"):format(ans), vim.log.Error)
        end
    end)
end

function M.rename_file_under_cursor()
    local path = netrw_get_current_file()
    local msg = ("Moving %s to : "):format(path)

    vim.ui.input({ prompt = msg, default = path, completion = "file" }, function(ans)
        if vim.fn.empty(ans) == 1 then
            return
        end

        rename(path, ans)
    end)
end

return M

-- }}}

-- vim: foldmethod=marker
