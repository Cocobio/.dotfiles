-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true


require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
        width = 25,
    },
    renderer = {
        indent_markers = {
            enable = true,
        },
    },
    filters = {
        dotfiles = true,
    },
    tab = {
        sync = {
            open = true,
            close = true,
        }
    },
})
