-- Author: Jaime Bowen Varela
-- Latex utils for tectonic

function replace_char(str, char_to_replace, replacement_char)
  local new_str = ""
  for i = 1, #str do
    local char = string.sub(str, i, i)
    if char == char_to_replace then
      new_str = new_str .. replacement_char
    else
      new_str = new_str .. char
    end
  end
  return new_str
end


function compile_tex()
    -- TODO: hacer que funcionen los paths. No funcionan si hay espacio entre los
    -- normbres rollo "carpeta loca/lol.text"
    -- Intuyo que es hacer una funcuon que cambie " " por "\ "
    --

    local command = "tectonic"
    
    local current_file = vim.api.nvim_get_current_buf()
    local current_file = vim.api.nvim_buf_get_name(current_file)
    local current_file = replace_char(current_file," ","\\ ")
    local extension = current_file:match("%.(%w+)$")

    if extension == "tex" then
        local cmd = command .. " " .. current_file
        vim.api.nvim_command("echo'"..cmd.."'")
        local success, output = pcall(vim.api.nvim_call_function, "system", {cmd})
        if success then
            vim.api.nvim_command("echo '"..output.."'")
        else
            vim.api.nvim_command("echo 'Error: "..output.."'")
        end
    else
        vim.api.nvim_command("echo 'Not .tex file in buffer'")
    end
end

function read_pdf()
    local current_file = vim.api.nvim_get_current_buf()
    local current_file = vim.api.nvim_buf_get_name(current_file)
    local current_file = replace_char(current_file," ","\\ ")
    local current_file = current_file:sub(1,-4) .. "pdf"
    print(current_file)
    local command = "open"
    local cmd = command .." ".. current_file
    local success, output = pcall(vim.api.nvim_call_function,"system",{cmd})
    if success then
        print("PDF abierto")
    else 
        print("No PDF found with that tex file name")
    end
end

function testLol()
    local cmd = "tectonic ".. "main.tex"
    local current_file = vim.api.nvim_buf_get_name(0)
    local success, output = pcall(vim.api.nvim_call_function, "system", {cmd})
    if success then
         vim.api.nvim_command("echo '"..current_file.."'")
    end
end
vim.api.nvim_set_keymap("n", "<leader>c", ":lua compile_tex()<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<leader>r", ":lua read_pdf()<CR>", {noremap = true})

