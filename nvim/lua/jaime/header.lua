-- ====================================
-- File: header.lua
-- Author: jaimebw
-- Created: 2025-04-01 23:22:59
-- ====================================

-- 🔹 Comment style map for known file extensions
local comment_styles = {
  v = "//",         -- Verilog
  sv = "//",        -- SystemVerilog
  c = "//",         -- C
  cpp = "//",       -- C++
  h = "//",         -- C header
  hpp = "//",       -- C++ header
  py = "#",         -- Python
  lua = "--",       -- Lua
  sh = "#",         -- Shell
  bash = "#",       -- Bash
  zsh = "#",        -- Zsh
  js = "//",        -- JavaScript
  ts = "//",        -- TypeScript
  jsx = "//",       -- React JSX
  tsx = "//",       -- React TSX
  java = "//",      -- Java
  go = "//",        -- Go
  rs = "//",        -- Rust
  php = "//",       -- PHP
  rb = "#",         -- Ruby
  pl = "#",         -- Perl
  md = "<!--",      -- Markdown (HTML comment)
  html = "<!--",    -- HTML
  xml = "<!--",     -- XML
  css = "/*",       -- CSS
  scss = "/*",      -- SCSS
  vim = "\"",       -- Vim script
}

-- 🔹 Get author from Git or default to \"XM\"
local function get_git_author()
  local handle = io.popen("git config user.name 2>/dev/null")
  if not handle then
    vim.notify("Could not get git author, using default", vim.log.levels.WARN)
    return "XM"
  end
  local result = handle:read("*a")
  local success, close_err = handle:close()
  if not success then
    vim.notify("Error closing git command: " .. (close_err or "unknown error"), vim.log.levels.WARN)
    return "XM"
  end
  -- Trim whitespace
  result = result:gsub("^%s*(.-)%s*$", "%1")
  return result ~= "" and result or "XM"
end

-- 🔹 Insert file header at top of buffer
local function insert_file_header()
  local filename = vim.fn.expand("%:t")
  local ext = vim.fn.expand("%:e"):lower() -- Convert to lowercase for consistency
  local comment = comment_styles[ext]

  -- Check if file is empty to avoid duplicate headers
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local is_empty = #lines == 1 and lines[1] == ""

  -- Special handling for HTML-like comments
  local closing_comment = ""
  if comment == "<!--" then
    closing_comment = " -->"
  elseif comment == "/*" then
    closing_comment = " */"
  end

  if not comment then
    vim.notify("No header inserted: unknown comment style for ." .. ext, vim.log.levels.WARN)
    return
  end

  local author = get_git_author()
  local date = os.date("%Y-%m-%d %H:%M:%S")
  local file = filename

  local header = {
    comment .. " ====================================" .. closing_comment,
    comment .. " File: " .. file .. closing_comment,
    comment .. " Author: " .. author .. closing_comment,
    comment .. " Created: " .. date .. closing_comment,
    comment .. " ====================================" .. closing_comment,
    ""
  }

  -- Check if there's already a header
  local first_lines = vim.api.nvim_buf_get_lines(0, 0, 6, false)
  for _, line in ipairs(first_lines) do
    if line:match("File:") and line:match("Author:") then
      vim.notify("Header already exists for: " .. file, vim.log.levels.WARN)
      return
    end
  end

  -- Insert at the top of buffer, pushing down existing lines
  vim.api.nvim_buf_set_lines(0, 0, 0, false, header)
  vim.notify("Header inserted for: " .. file, vim.log.levels.INFO)
end

-- 🔹 Auto insert header on new files
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*",
  callback = function()
    local ext = vim.fn.expand("%:e"):lower() -- Convert to lowercase
    if comment_styles[ext] then
      -- Delay slightly to ensure buffer is ready
      vim.defer_fn(function()
        insert_file_header()
      end, 10)
    end
  end,
})

-- 🔹 Manual keybinding: <leader>n
vim.keymap.set("n", "<leader>n", insert_file_header, { desc = "Insert file header" })
