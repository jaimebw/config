function ColorMyPencils(color)
	color = color or "kanagawa" -- rose-pine
	vim.cmd.colorscheme(color)
	vim.api.nvim_set_hl(0,"Normal",{bg = "none"})
	vim.api.nvim_set_hl(0,"NormalFloat",{bg = "none"})
    --vim.cmd("highlight Normal ctermbg=NONE")
end

ColorMyPencils()

