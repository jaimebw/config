-- ====================================
-- File: cursor.lua
-- Author: jaimebw
-- Created: 2025-04-03 00:00:00
-- ====================================

-- Configuración del cursor para Neovim
-- Documentación: https://neovim.io/doc/user/options.html#'guicursor'

-- Configuración de colores del cursor
local function setup_cursor_colors()
    -- Definir colores para diferentes modos
    -- Puedes cambiar estos colores según tus preferencias
    local colors = {
        normal = "#61AFEF",  -- Azul para modo normal
        insert = "#98C379",  -- Verde para modo inserción
        visual = "#C678DD",  -- Púrpura para modo visual
        replace = "#E06C75", -- Rojo para modo reemplazo
        command = "#E5C07B"  -- Amarillo para modo comando
    }

    -- Configurar los colores para cada modo
    vim.api.nvim_set_hl(0, "Cursor", { bg = colors.normal, fg = "#282C34" })
    vim.api.nvim_set_hl(0, "CursorIM", { bg = colors.insert, fg = "#282C34" })
    vim.api.nvim_set_hl(0, "VisualCursor", { bg = colors.visual, fg = "#282C34" })
    vim.api.nvim_set_hl(0, "ReplaceCursor", { bg = colors.replace, fg = "#282C34" })
    vim.api.nvim_set_hl(0, "CommandCursor", { bg = colors.command, fg = "#282C34" })

    -- asdasd el estilo del cursor para diferentes modos
    -- n-v-c: Normal, Visual, Command-line
    -- i-ci: Insert, Command-line insert
    -- r-cr: Replace, Command-line replace
    -- o: Operator-pending
    -- ve: Visual-exclude
    -- sm: Showmatch
    vim.opt.guicursor = {
        "n-v:block-Cursor/lCursor",
    "i-ci:ver25-CursorIM/lCursor",
    "r-cr:hor20-ReplaceCursor/lCursor",
    "o:hor50-CommandCursor/lCursor",
    "a:blinkwait700-blinkoff400-blinkon250",
    "sm:block-blinkwait175-blinkoff150-blinkon175"}

    --Aegurarse de que termguicolors esté activado para que los colores funcionen correctamente
    vim.opt.termguicolors = true
end

-- Inicializar la configuración del cursor
setup_cursor_colors()

-- Función para cambiar el color del cursor manualmente
-- Puedes llamar a esta función con :lua change_cursor_color("#FF0000") para cambiar a rojo
_G.change_cursor_color = function(color)
    vim.api.nvim_set_hl(0, "Cursor", { bg = color, fg = "#282C34" })
    vim.notify("Cursor color changed to " .. color, vim.log.levels.INFO)
end

-- Comando para cambiar el color del cursor desde la línea de comandos
vim.api.nvim_create_user_command("CursorColor", function(opts)
    _G.change_cursor_color(opts.args)
end, { nargs = 1, desc = "Change cursor color (hex format: #RRGGBB)" })

return {
    setup_cursor_colors = setup_cursor_colors,
    change_cursor_color = _G.change_cursor_color
}
