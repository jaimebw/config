-- ====================================
-- File: local_info.lua
-- Author: jaimebw
-- Created: 2025-04-04 22:10:26
-- ====================================

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

