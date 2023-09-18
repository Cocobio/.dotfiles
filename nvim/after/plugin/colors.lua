local colors = {
    "tokyonight-night",
    "tokyonight-moon",
    "tokyonight-storm",
    "catppuccin-mocha",
    "catppuccin-frappe",
    "catppuccin-macchiato",
    "noctis",
    "noctis_azureus",
    "noctis_minimus",
    "noctis_uva",
    "noctis_viola",
    "noctis_sereno",
    "noctis_obscuro",
    "rose-pine-moon",
    "rose-pine-main",
    "oxocarbon",
}

function ColorMyPencils(color)
	color = color or colors[math.random(#colors)]
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ColorMyPencils()
