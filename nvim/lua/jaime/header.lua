-- 🔹 Comment style map for known file extensions
local comment_styles = {
  v = "//",         -- Verilog
  sv = "//",        -- SystemVerilog
  c = "//",         -- C
  cpp = "//",       -- C++
  h = "//",         -- C header
  py = "#",         -- Python
  lua = "--",       -- Lua
  sh = "#",         -- Shell
}

-- 🔹 Get author from Git or default to \"XM\"
local function get_git_author()
  local handle = io.popen("git config user.name 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    result = result:gsub("%s+$", "")
    return result ~= "" and result or "XM"
  end
  return "XM"
end

-- 🔹 Insert file header at top of buffer
local function insert_file_header()
  local ext = vim.fn.expand("%:e")
  local comment = comment_styles[ext]

  if not comment then
    vim.notify("No header inserted: unknown comment style for ." .. ext, vim.log.levels.WARN)
    return
  end

  local author = get_git_author()
  local date = os.date("%Y-%m-%d %H:%M:%S")
  local file = vim.fn.expand("%:t")

  local header = {
    comment .. " ====================================",
    comment .. " File: " .. file,
    comment .. " Author: " .. author,
    comment .. " Created: " .. date,
    comment .. " ====================================",
    ""
  }

  -- Insert at the top of buffer, pushing down existing lines
  vim.api.nvim_buf_set_lines(0, 0, 0, false, header)
  vim.notify("Header inserted for: " .. file, vim.log.levels.INFO)
end

-- 🔹 Auto insert header on new files
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*",
  callback = function()
    local ext = vim.fn.expand("%:e")
    if comment_styles[ext] then
      insert_file_header()
    end
  end,
})

-- 🔹 Manual keybinding: <leader>n
vim.keymap.set("n", "<leader>n", insert_file_header, { desc = "Insert file header" })

