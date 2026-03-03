local telescope = require('telescope')
local actions = require('telescope.actions')
local builtin = require('telescope.builtin')

local find_files = builtin.find_files
local git_files = builtin.git_files
local grep_string = builtin.grep_string

local file_ignore_patterns = { "node_modules", ".git/", "venv","__pycache__","target",".ipynb_checkpoints"}
local telescope_help_group = vim.api.nvim_create_augroup('JaimeTelescopeHelp', { clear = true })
local telescope_help_state = {
    help_buf = nil,
    help_win = nil,
}

local telescope_help_items = {
    { '<leader>pf', 'project files' },
    { '<leader>pa', 'all files' },
    { '<C-p>', 'git files' },
    { '<leader>ps', 'grep string' },
    { '<Leader>db', 'dap breakpoints' },
    { '<Leader>df', 'dap frames' },
    { '<Leader>dv', 'dap variables' },
    { '<C-n>/<Down>', 'next item' },
    { '<C-p>/<Up>', 'previous item' },
    { '<CR>', 'open selection' },
    { '<C-x>', 'horizontal split' },
    { '<C-v>', 'vertical split' },
    { '<C-t>', 'open in tab' },
    { '<Esc>/q', 'close picker' },
}

local function fit_help_text(text, max_width)
    if #text <= max_width then
        return text
    end

    if max_width <= 3 then
        return text:sub(1, max_width)
    end

    return text:sub(1, max_width - 3) .. '...'
end

local function build_telescope_help_lines(width)
    local column_gap = '    '
    local inner_width = math.max(width - 2, 24)
    local column_width = math.max(math.floor((inner_width - #column_gap) / 2), 12)
    local lines = {}

    for index = 1, #telescope_help_items, 2 do
        local left = telescope_help_items[index]
        local left_text = fit_help_text(left[1] .. '  ' .. left[2], column_width)
        local line = string.format('%-' .. column_width .. 's', left_text)
        local right = telescope_help_items[index + 1]

        if right then
            local right_text = fit_help_text(right[1] .. '  ' .. right[2], column_width)
            line = line .. column_gap .. right_text
        end

        lines[#lines + 1] = line
    end

    return lines
end

local function matches_filetype(filetype, allowed_filetypes)
    for _, allowed in ipairs(allowed_filetypes) do
        if filetype == allowed then
            return true
        end
    end

    return false
end

local function close_telescope_help()
    if telescope_help_state.help_win and vim.api.nvim_win_is_valid(telescope_help_state.help_win) then
        vim.api.nvim_win_close(telescope_help_state.help_win, true)
    end

    telescope_help_state.help_win = nil
    telescope_help_state.help_buf = nil
end

local function get_telescope_bounds(allowed_filetypes)
    local min_row
    local min_col
    local max_row
    local max_col

    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        local filetype = vim.bo[buf].filetype

        if matches_filetype(filetype, allowed_filetypes) then
            local config = vim.api.nvim_win_get_config(win)

            if config.relative ~= '' then
                local row = math.floor(tonumber(config.row) or 0)
                local col = math.floor(tonumber(config.col) or 0)
                local width = config.width or vim.api.nvim_win_get_width(win)
                local height = config.height or vim.api.nvim_win_get_height(win)

                min_row = min_row and math.min(min_row, row) or row
                min_col = min_col and math.min(min_col, col) or col
                max_row = max_row and math.max(max_row, row + height) or (row + height)
                max_col = max_col and math.max(max_col, col + width) or (col + width)
            end
        end
    end

    return min_row, min_col, max_row, max_col
end

local function open_telescope_help(prompt_buf)
    if not vim.api.nvim_buf_is_valid(prompt_buf) then
        return
    end

    close_telescope_help()

    local min_row, min_col, max_row, max_col = get_telescope_bounds({ 'TelescopePrompt', 'TelescopeResults' })

    if not min_row then
        min_row, min_col, max_row, max_col = get_telescope_bounds({ 'TelescopePrompt', 'TelescopeResults', 'TelescopePreview' })
    end

    local editor_width = vim.o.columns
    local editor_height = math.max(vim.o.lines - vim.o.cmdheight - 1, 1)
    local max_width = math.max(editor_width - min_col - 1, 24)
    local width = math.min(math.max(max_col - min_col, 48), max_width)
    local help_lines = build_telescope_help_lines(width)
    local row = math.min(max_row + 1, math.max(editor_height - 1, 0))
    local col = min_col
    local available_below = math.max(editor_height - row, 1)
    local height = math.min(#help_lines, available_below)

    if col + width > editor_width then
        col = math.max(editor_width - width, 0)
    end

    local help_buf = vim.api.nvim_create_buf(false, true)
    vim.bo[help_buf].bufhidden = 'wipe'
    vim.bo[help_buf].buflisted = false
    vim.bo[help_buf].filetype = 'TelescopePromptHelp'
    vim.bo[help_buf].modifiable = true
    vim.bo[help_buf].swapfile = false
    vim.api.nvim_buf_set_lines(help_buf, 0, -1, false, help_lines)
    vim.bo[help_buf].modifiable = false

    local ok, help_win = pcall(vim.api.nvim_open_win, help_buf, false, {
        relative = 'editor',
        row = row,
        col = col,
        width = width,
        height = height,
        style = 'minimal',
        border = 'rounded',
        title = ' Keys ',
        title_pos = 'left',
    })

    if not ok then
        vim.api.nvim_buf_delete(help_buf, { force = true })
        return
    end

    vim.wo[help_win].cursorline = false
    vim.wo[help_win].foldenable = false
    vim.wo[help_win].number = false
    vim.wo[help_win].relativenumber = false
    vim.wo[help_win].signcolumn = 'no'
    vim.wo[help_win].spell = false
    vim.wo[help_win].winfixheight = true
    vim.wo[help_win].winfixwidth = true
    vim.wo[help_win].wrap = false
    vim.wo[help_win].winhl = 'Normal:TelescopeNormal,FloatBorder:TelescopeBorder'

    telescope_help_state.help_buf = help_buf
    telescope_help_state.help_win = help_win

    vim.api.nvim_create_autocmd({ 'BufHidden', 'BufWipeout' }, {
        group = telescope_help_group,
        buffer = prompt_buf,
        once = true,
        callback = close_telescope_help,
    })
end

telescope.setup({
    defaults = {
        mappings = {
            i = {
                ['<C-n>'] = actions.move_selection_next,
                ['<C-p>'] = actions.move_selection_previous,
                ['<Down>'] = actions.move_selection_next,
                ['<Up>'] = actions.move_selection_previous,
                ['<CR>'] = actions.select_default,
                ['<C-x>'] = actions.select_horizontal,
                ['<C-v>'] = actions.select_vertical,
                ['<C-t>'] = actions.select_tab,
                ['<Esc>'] = actions.close,
            },
            n = {
                ['j'] = actions.move_selection_next,
                ['k'] = actions.move_selection_previous,
                ['<CR>'] = actions.select_default,
                ['<C-x>'] = actions.select_horizontal,
                ['<C-v>'] = actions.select_vertical,
                ['<C-t>'] = actions.select_tab,
                ['q'] = actions.close,
            },
        },
    },
})

telescope.load_extension('dap')

vim.api.nvim_create_autocmd('FileType', {
    group = telescope_help_group,
    pattern = 'TelescopePrompt',
    callback = function(args)
        vim.schedule(function()
            open_telescope_help(args.buf)
        end)
    end,
})

-- Find files
vim.keymap.set('n', '<leader>pf', function()
    find_files({
        file_ignore_patterns = file_ignore_patterns,
        hidden = true,
    })
end, {})

vim.keymap.set('n', '<leader>pa', function()
    find_files({
    })
end, {})

-- Git files
vim.keymap.set('n', '<C-p>', function()
    git_files({
        file_ignore_patterns = file_ignore_patterns,
        hidden = true,
    })
end, {})

-- Grep string
vim.keymap.set('n', '<leader>ps', function()
    grep_string({
        search = vim.fn.input("Grep > "),
        file_ignore_patterns = file_ignore_patterns,
    })
end,{})

-- List Breakpoints: Show all breakpoints
vim.keymap.set('n', '<Leader>db', ':Telescope dap list_breakpoints<CR>', {desc = 'List Breakpoints'})

-- List Frames: Show call stack frames
vim.keymap.set('n', '<Leader>df', ':Telescope dap frames<CR>', {desc = 'List Frames'})

-- List Variables: Show variables in the current scope
vim.keymap.set('n', '<Leader>dv', ':Telescope dap variables<CR>', {desc = 'List Variables'})
