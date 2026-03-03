-- ====================================
-- File: local_info.lua
-- Author: jaimebw
-- Created: 2025-04-04 22:10:26
-- ====================================

local startup_message_lines = {
  "████                                                               ",
  "                                                                                           ███   ██                                                               ",
  "                                                                                      ████       ██               ████████████                                    ",
  "                                                                                  █████         ███           ████            █                                    ",
  "                                                                              ████             █           ███             ███                                    ",
  "                                                                           ███                          ███            ████                                       ",
  "                                                                          ██                         ██              ██                                           ",
  "                                                                          ██                      ██             ███                                              ",
  "                                                                          █                   ██              ███                                                 ",
  "                                                                          ████                                 █                                                  ",
  "                                                                            ██                                 ██                                                 ",
  "                                                                            ██                                  ███    █                                          ",
  "                                                                            ██                                         █                                          ",
  "                                                                            ██                                         █                                          ",
  "                                                                         ████                                          █                                          ",
  "                                                                   █████                                       ████    █                                          ",
  "                                                               ███                        █████████          ██   █                                               ",
  "                                                            ███                        █████████████         █    ██    ███                                       ",
  "                                                          ██                        ███████                ██     ██       █                                      ",
  "                                                         █                                                ██       █     ██                                       ",
  "                                                        █    ██                             ███         ██           ███                                          ",
  "                                                      ██     ██               █████     ████    ██████                                                            ",
  "                                                      █                      ██                                                                                   ",
  "                                                     █                      ██                                                                                    ",
  "                                                    ████                   ██                                                                                     ",
  "                                                  █████████              ██                                                                                       ",
  "                                                █████████████          ██                                                                                         ",
  "                                              ████████████████     ████                                                                                           ",
  "                                             █████████████████████                                                                                                ",
  "                                            ███████████████████                                                                                                   ",
  "                                          ████████████████████                                                                                                    ",
  "                                         ████████████████████                                                                                                     ",
  "                                        ████████████████████                                                                                                      ",
  "                                       ███████████████████                                                                                                        ",
  "                                      ███████████████████                                                                                                         ",
  "                                     ██████████████████                                                                                                           ",
  "                                    █████████████████                                                                                                             ",
  "                                   ████████████████                                                                                                               ",
  "                                   █████████████                                                                                                                  ",
  "                                   ██████████                                                                                                                     ",
  "                                  ███████",
}
local startup_splash_ns = vim.api.nvim_create_namespace("JaimeStartupSplash")
local startup_splash = {
  win = nil,
}

local function close_startup_message()
  if startup_splash.win and vim.api.nvim_win_is_valid(startup_splash.win) then
    vim.api.nvim_win_close(startup_splash.win, true)
  end

  startup_splash.win = nil
  vim.on_key(nil, startup_splash_ns)
end

local function longest_line(lines)
  local width = 0

  for _, line in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(line))
  end

  return width
end

local function show_startup_message()
  local buf = vim.api.nvim_create_buf(false, true)
  local lines = vim.deepcopy(startup_message_lines)

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].buflisted = false
  vim.bo[buf].modifiable = false

  local max_width = math.max(vim.o.columns - 4, 1)
  local editor_height = math.max(vim.o.lines - vim.o.cmdheight - 2, 1)
  local max_height = math.max(editor_height - 2, 1)
  local width = math.min(longest_line(lines), max_width)
  local height = math.min(#lines, max_height)
  local opts = {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = math.max(math.floor((editor_height - height) / 2), 0),
    col = math.max(math.floor((vim.o.columns - width) / 2), 0),
  }

  close_startup_message()

  local win = vim.api.nvim_open_win(buf, false, opts)
  startup_splash.win = win

  vim.wo[win].cursorline = false
  vim.wo[win].foldenable = false
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn = "no"
  vim.wo[win].wrap = false
  vim.wo[win].winfixheight = true
  vim.wo[win].winfixwidth = true
  vim.wo[win].winhl = "Normal:Normal,FloatBorder:Normal"

  vim.on_key(function()
    vim.schedule(close_startup_message)
  end, startup_splash_ns)
end

local function show_info_window()
  local buf = vim.api.nvim_create_buf(false, true)

  local info_lines = {
    "🚀 Custom Command Info",
    "Mode: " .. vim.fn.mode(),
    "Time: " .. os.date("%H:%M:%S"),
    "This windows:\t\t space + i",
    "Telecospe find:\t\t  space + f",
    "Telecospe git files:\t\t space + Control p",
    "Telecospe findall:\t\t  space + a",
    "Add header:\t\t space +n"

  }

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, info_lines)

  local width = 50
  local height = #info_lines
  local opts = {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = 2,
    col = vim.o.columns - width - 2,
    border = "rounded"
  }

  local win = vim.api.nvim_open_win(buf, false, opts)

  vim.defer_fn(function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end, 3000) -- close after 3 seconds
end

vim.keymap.set("n", "<leader>i", show_info_window, { desc = "Show custom info window" })

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.schedule(show_startup_message)
  end,
})
